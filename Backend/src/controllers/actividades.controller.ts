import express, { Request, Response } from "express";
import { Prisma, PrismaClient } from "@prisma/client";
import multer from "multer";
import path from "path";
import { DominioIP } from "../global";

const prisma = new PrismaClient();
export async function getActividades(req: Request, res: Response) {
  try {
    const { Tipo, Nombre, Descripcion, FechaFinal } = req.body;

    const Activades = await prisma.actividades.findMany();
    return res.json(Activades);
  } catch (error) {
    console.error(error);
    console.log("no");

    return res
      .status(500)
      .json([{ status: "ERROR", mensaje: "Contrasena incorrecta" }]);
  }
}
export async function CreateActividad(req: Request, res: Response) {
  try {
    const { Tipo, Nombre, Descripcion, FechaFinal } = req.body;
    const Users = await prisma.users.findMany({ where: { Rol: "ALUMNO" } });
    const Activades = await prisma.actividades.create({
      data: {
        Nombre: Nombre,
        Descripcion: Descripcion,
        Tipo: Tipo,
        FechaPara: new Date(FechaFinal),
      },
    });

    const Evidencias = await prisma.evidenciaActividad.createMany({
      data: Users.map((value) => ({
        ActividadID: Activades.id,
        AlumnoID: value.id,
        Nombre: `Activdad - ${Activades.id}`,
      })),
    });
    const Resp = await prisma.actividades.findMany({
      where: { id: Activades.id },
    });
    //   createMany: { data: Users.map((value) => ({AlumnoID:value.id,Nombre:`Activdad - ${id}`,Descripcion:"Mensaje"})) },
    return res.json(Activades);
  } catch (error) {
    console.error(error);
    console.log("no");

    return res
      .status(500)
      .json([{ status: "ERROR", mensaje: "Contrasena incorrecta" }]);
  }
}
export async function UpdateActividad(req: Request, res: Response) {
  try {
    const { IDActividad } = req.params;
    const { Tipo, Nombre, Descripcion, FechaFinal } = req.body;

    const Activades = await prisma.actividades.update({
      where: { id: parseInt(IDActividad) },
      data: {
        Nombre: Nombre,
        Descripcion: Descripcion,
        Tipo: Tipo,
        FechaPara: new Date(FechaFinal),
      },
    });
    return res.json(Activades);
  } catch (error) {
    console.error(error);
    console.log("no");

    return res
      .status(500)
      .json([{ status: "ERROR", mensaje: "Contrasena incorrecta" }]);
  }
}
export async function EliminarActividad(req: Request, res: Response) {
  try {
    const { IDActividad } = req.params;

    const Activades = await prisma.actividades.delete({
      where: { id: parseInt(IDActividad) },
    });
    return res.json(Activades);
  } catch (error) {
    console.error(error);
    console.log("no");

    return res
      .status(500)
      .json([{ status: "ERROR", mensaje: "Contrasena incorrecta" }]);
  }
}

export async function GetAlumosEvidence(req: Request, res: Response) {
  try {
    const { IDActividad } = req.params;

    const Activades = await prisma.evidenciaActividad.findMany({
      orderBy: [
        {
          Alumno: {
            Nombre: "asc",
          },
        },
      ],
      where: { ActividadID: parseInt(IDActividad) },
      include: { Alumno: { select: { Nombre: true } } },
    });
    return res.json(Activades);
  } catch (error) {
    console.error(error);
    console.log("no");

    return res
      .status(500)
      .json([{ status: "ERROR", mensaje: "Contrasena incorrecta" }]);
  }
}
//Evidencias

//file related stuff

export const StorageGroupIcon = multer.diskStorage({
  destination: async (req, file, cb) => {
    let dir = "uploads";
    cb(null, dir);
  },
  filename: async (req, file, cb) => {
    const { IDActividad } = req.params;
    const { Nombre, Descripcion, AlumnoID } = req.body;
    console.log("si: " + req.file?.size);
    let NombreArchivo = file.originalname;

    await prisma.evidenciaActividad.create({
      data: {
        Nombre: Nombre,
        Descripcion: Descripcion,
        ActividadID: parseInt(IDActividad),
        AlumnoID: parseInt(AlumnoID),
        //file related
        NombreArchivo: NombreArchivo,
        EvidenciaURL: `${DominioIP}/archivo/${NombreArchivo}`,
        RutaArchivo: file.destination || "",
      },
    });

    cb(null, NombreArchivo);
  },
});
