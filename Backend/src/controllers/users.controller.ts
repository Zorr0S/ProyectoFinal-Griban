import express, { Request, Response } from "express";
import { Prisma, PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

export async function LoginProfesor(req: Request, res: Response) {
  try {
    const { User, Password } = req.body;
    if (User == undefined || Password == undefined)
      throw { msg: "Campos vacios" };
    const Login = await prisma.users.findFirstOrThrow({
      where: { AND: [{ UserName: User }, { Contrasena: Password },{Rol:"PROFESOR"}] },
      select: { id: true, UserName: true },
    });
    console.log("Logead")
    return res.json(Login);
  } catch (error) {
    console.error(error);
    console.log("no")

    return  res
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
      where: { AND: [{ UserName: User }, { Contrasena: Password },{Rol:"PROFESOR"}] },
      select: { id: true, UserName: true },
    });
    console.log("Logead")
    return res.json(Login);
  } catch (error) {
    console.error(error);
    console.log("no")

    return  res
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
    const datos = await prisma.users.findMany({
      where: { Rol: "ALUMNO" },
      orderBy:[{Nombre:"desc"}],
      select: {
        Nombre: true,
        Asistencias: {
        
          include: {
            Registro: true,
          },
        },
        EvidenciaActividad:true

      },
    });
   return res.json(datos);
  } catch (error) {
    console.error(error);
    res.status(500).json([{ status: "ERROR", mensaje: "Ocurrio un error" }]);
  }
}

