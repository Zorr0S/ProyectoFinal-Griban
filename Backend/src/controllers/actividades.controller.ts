import express, { Request, Response } from "express";
import { Prisma, PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();
export async function getActividades(req: Request, res: Response) {
  try {
    const { Tipo, Nombre, Descripcion, FechaFinal } = req.body;

    const Activades = await prisma.actividades.create({
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
export async function CreateActividad(req: Request, res: Response) {
  try {
    const { Tipo, Nombre, Descripcion, FechaFinal } = req.body;

    const Activades = await prisma.actividades.create({
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

export async function GetAlumosEvidence(req: Request, res: Response) {
  try {
    const { IDActividad } = req.params;

    const Activades = await prisma.evidenciaActividad.findMany({
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
