import express, { Request, Response } from "express";
import {
  Asistencias,
  Prisma,
  PrismaClient,
  RegistroAsistencia,
} from "@prisma/client";

const prisma = new PrismaClient();

export async function LoginProfesor(req: Request, res: Response) {
  try {
    const { User, Password } = req.body;
    if (User == undefined || Password == undefined)
      throw { msg: "Campos vacios" };
    const Login = await prisma.users.findFirstOrThrow({
      where: {
        AND: [
          { UserName: User },
          { Contrasena: Password },
          { Rol: "PROFESOR" },
        ],
      },
      select: { id: true, UserName: true },
    });
    console.log("Logead");
    return res.json(Login);
  } catch (error) {
    console.error(error);
    console.log("no");

    return res
      .status(500)
      .json([{ status: "ERROR", mensaje: "Contrasena incorrecta" }]);
  }
}
export async function Login(req: Request, res: Response) {
  try {
    const { User, Password } = req.body;
    if (User == undefined || Password == undefined)
      throw { msg: "Campos vacios" };
    const Login = await prisma.users.findFirstOrThrow({
      where: {
        AND: [
          { UserName: User },
          { Contrasena: Password },
          { Rol: "ALUMNO" },
        ],
      },
      select: { id: true, UserName: true },
    });
    console.log("Logead");
    return res.json(Login);
  } catch (error) {
    console.error(error);
    console.log("no");

    return res
      .status(500)
      .json([{ status: "ERROR", mensaje: "Contrasena incorrecta" }]);
  }
}

export async function Register(req: Request, res: Response) {
  try {
    const { Nombre, User, Password } = req.body;
    const Registro = await prisma.users.create({
      data: {
        Nombre: Nombre,
        UserName: User,
        Contrasena: Password,
      },
    });
    res.json(Registro);
  } catch (error) {
    console.error(error);
    res.status(500).json([{ status: "ERROR", mensaje: "Ocurrio un error" }]);
  }
}

export async function getDatosUser(req: Request, res: Response) {
  try {
    const users = await prisma.users.findMany({
      where: { Rol: "ALUMNO" },
      orderBy: [{ Nombre: "asc" }],
      select: {
        id: true,
        Nombre: true,
        Asistencias: {
          include: {
            Registro: true,
          },
        },
        EvidenciaActividad: { include: { Calificacion: true } },
      },
    });
    const Activiadaes = await prisma.actividades.count();

    let Datos: Desgloce[] = [];
    for (let index = 0; index < users.length; index++) {
      let Asistencia = AsistenciasPorcentage(users[index].Asistencias);
      let auxExa = ((await GetExamenCal(users[index].id)) / 10)*100;
      let auxPorta = ((await GetPortafolioCal(users[index].id)) / 10)*100;
      let auxActCom = ((await GetActividadesComCal(users[index].id)) / 10)*100;
      let ActividadesEntre = await GetActividadeEntregadas(users[index].id)
      Datos.push({
        Nombre: users[index].Nombre,
        ValorExamen: auxExa,
        PortaFolio: auxPorta,
        ActividadCom: auxActCom,
        Asistencia:Asistencia ,
        ActividadesEntregadas:ActividadesEntre,
        EnRiesgo: IsRiesgoRepro(Asistencia, ActividadesEntre),
        Excento: IsExcento(Asistencia, ActividadesEntre),
        Total: (auxExa*0.4) + (auxPorta*0.4)+(Asistencia*0.2)
      });
    }

    return res.json(Datos);
  } catch (error) {
    console.error(error);
    res.status(500).json([{ status: "ERROR", mensaje: "Ocurrio un error" }]);
  }
}
async function GetExamenCal(idUser: number) {
  const Examenes = await prisma.evidenciaActividad.findMany({
    where: { AND: [{ Actividad: { Tipo: "EXAMEN" } }, { AlumnoID: idUser }] },
    include: { Calificacion: true },
  });
  let Valor = 0;
  for (let index = 0; index < Examenes.length; index++) {
    Valor += Examenes[index].Calificacion.valor.toNumber();
  }
  return (Valor / Examenes.length) | 0;
}
async function GetPortafolioCal(idUser: number) {
  const Portafolio = await prisma.evidenciaActividad.findMany({
    where: {
      AND: [{ Actividad: { Tipo: "PORTAFOLIO" } }, { AlumnoID: idUser }],
    },
    include: { Calificacion: true },
  });
  let Valor = 0;
  for (let index = 0; index < Portafolio.length; index++) {
    Valor += Portafolio[index].Calificacion.valor.toNumber();
  }

  return (Valor / Portafolio.length) | 0;
}
async function GetActividadesComCal(idUser: number) {
  const ActividadCom = await prisma.evidenciaActividad.findMany({
    where: {
      AND: [
        { Actividad: { Tipo: "ACTIVIDADCOMPLEMENTARIA" } },
        { AlumnoID: idUser },
      ],
    },
    include: { Calificacion: true },
  });
  let Valor = 0;
  for (let index = 0; index < ActividadCom.length; index++) {
    Valor += ActividadCom[index].Calificacion.valor.toNumber();
  }
  return (Valor / ActividadCom.length) | 0;
}

async function GetActividadeEntregadas(idUser: number) {
  const ToalActividades = await prisma.actividades.count();
  const ActividadesCom = await prisma.evidenciaActividad.findMany({
    where: { AND: [{ Estado: "A_TIEMPO" }, { AlumnoID: idUser }] },
    include: { Calificacion: true },
  });
  return ActividadesCom.length / ToalActividades;
}
function AsistenciasPorcentage(
  datos: (Asistencias & {
    Registro: RegistroAsistencia;
  })[]
) {
  let Retrasos = datos.filter((e) => e.Registro.Letra == "R");
  let asistencias = datos.filter((e) => e.Registro.Letra == "A");
  let Justificacion = datos.filter((e) => e.Registro.Letra == "J");

  let valorRetrasos = Math.trunc(Retrasos.length / 3);
  let valorRetrasosPositivos = Retrasos.length % 3;

  let valor =
    asistencias.length +
    Justificacion.length -
    valorRetrasos +
    valorRetrasosPositivos;

  return (valor / datos.length) * 100;
}

function IsRiesgoRepro(asistencia: number, actividades: number) {
  if (asistencia < 0.8 && actividades < 0.5) {
    return true;
  }
  return false;
}
function IsExcento(asistencia: number, actividades: number) {
  if (asistencia >= 0.95 && actividades >= 0.9) {
    return true;
  }
  return false;
}

interface Desgloce {
  Nombre: string;
  ValorExamen: number;
  PortaFolio: number;
  ActividadCom: number;
  ActividadesEntregadas:number;
  Asistencia: number;
  EnRiesgo: boolean;
  Excento: boolean;
  Total:number
}



export async function getDatoUserbyID(req: Request, res: Response) {
  try {
    const {IDUser}= req.params;
    const users = await prisma.users.findFirstOrThrow({
      where: { AND:[{id: parseInt(IDUser)},{ Rol: "ALUMNO"}] },
      orderBy: [{ Nombre: "asc" }],
      select: {
        id: true,
        Nombre: true,
        Asistencias: {
          include: {
            Registro: true,
          },
        },
        EvidenciaActividad: { include: { Calificacion: true } },
      },
    });
    const Activiadaes = await prisma.actividades.count();

    let Datos: Desgloce 
      let Asistencia = AsistenciasPorcentage(users.Asistencias);
      let auxExa = ((await GetExamenCal(users.id)) / 10)*100;
      let auxPorta = ((await GetPortafolioCal(users.id)) / 10)*100;
      let auxActCom = ((await GetActividadesComCal(users.id)) / 10)*100;
      let ActividadesEntre = await GetActividadeEntregadas(users.id)
      Datos={
        Nombre: users.Nombre,
        ValorExamen: auxExa,
        PortaFolio: auxPorta,
        ActividadCom: auxActCom,
        Asistencia:Asistencia ,
        ActividadesEntregadas:ActividadesEntre,
        EnRiesgo: IsRiesgoRepro(Asistencia, ActividadesEntre),
        Excento: IsExcento(Asistencia, ActividadesEntre),
        Total: (auxExa*0.4) + (auxPorta*0.4)+(Asistencia*0.2)
      };

    return res.json(Datos);
  } catch (error) {
    console.error(error);
    res.status(500).json([{ status: "ERROR", mensaje: "Ocurrio un error" }]);
  }
}