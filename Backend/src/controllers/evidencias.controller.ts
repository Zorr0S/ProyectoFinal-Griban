import express, { Request, Response } from "express";
import { Prisma, PrismaClient } from "@prisma/client";
import multer from "multer";
import path from "path";
import { DominioIP } from "../global";

const prisma = new PrismaClient();
export async function GetAlumosEvidence(req: Request, res: Response) {
  try {
    const { IDActividad } = req.params;

    const Actividad = await prisma.actividades.findFirstOrThrow({
      where: { id: parseInt(IDActividad) },
    });

    const evidencia = await prisma.evidenciaActividad.findMany({
      where: { ActividadID: parseInt(IDActividad) },
      include: { Calificacion:true, Alumno: { select: { Nombre: true }, } },
    });

    evidencia.forEach(async (element) => {
      if (element.FechaSubida != null) {
        if (element.FechaSubida > Actividad.FechaPara) {
          await prisma.evidenciaActividad.update({
            where: { id: element.id },
            data: { Estado: "ASTRASO" },
          });
        } else if (Actividad.FechaPara < element.FechaSubida) {
          await prisma.evidenciaActividad.update({
            where: { id: element.id },
            data: { Estado: "A_TIEMPO" },
          });
        }
      } else if (
        new Date() > Actividad.FechaPara &&
        element.FechaSubida == null
      ) {
        await prisma.evidenciaActividad.update({
          where: { id: element.id },
          data: { Estado: "ASTRASO" },
        });
      }
    });

    const vista = await prisma.evidenciaActividad.findMany({
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
    return res.json(evidencia);
  } catch (error) {
    console.error(error);
    console.log("no");

    return res
      .status(500)
      .json([{ status: "ERROR", mensaje: "Contrasena incorrecta" }]);
  }
}

export async function changeCal(req: Request, res: Response) {
  try {
    const { IDActividad } = req.params;
    const { CalificacionID } = req.body;

    console.log("Entro")

    const calificacion = await prisma.evidenciaActividad.update({
      where: { id: parseInt(IDActividad) },
      data:{
        CalificacionID: parseInt(CalificacionID)
      }
    });
    return res.json(calificacion);
  } catch (error) {
    console.error(error);
    console.log("no");

    return res
      .status(500)
      .json([{ status: "ERROR", mensaje: "Contrasena incorrecta" }]);
  }
}

export async function EntregarEvidencia(req: Request, res: Response) {
  try {
    const { IDActividad } = req.params;
    const {Nombre,Descripcion, IdAlumno} = req.body;

    console.log("Entro")

  
    const calificacion = await prisma.evidenciaActividad.update({
      where: { AlumnoID_ActividadID:{
        ActividadID:parseInt(IDActividad),
        AlumnoID:IdAlumno
      }},
      data:{
        Nombre,
        Descripcion,
       FechaSubida: new Date() 
      }
    });
    await ActualizarEstado(IDActividad);

    return res.json(calificacion);
  } catch (error) {
    console.error(error);
    console.log("no");

    return res
      .status(500)
      .json([{ status: "ERROR", mensaje: "Contrasena incorrecta" }]);
  }

  async function ActualizarEstado(IDActividad: string) {
    const Actividad = await prisma.actividades.findFirstOrThrow({
      where: { id: parseInt(IDActividad) },
    });
    console.log("Actualizo")


    const evidencia = await prisma.evidenciaActividad.findMany({
      where: { ActividadID: parseInt(IDActividad) },
      include: { Calificacion: true, Alumno: { select: { Nombre: true }, } },
    });

    evidencia.forEach(async (element) => {
      if (element.FechaSubida != null) {
        if (element.FechaSubida > Actividad.FechaPara) {
          await prisma.evidenciaActividad.update({
            where: { id: element.id },
            data: { Estado: "ASTRASO" },
          });
          console.log("ASTRASO")

        } else if ( element.FechaSubida < Actividad.FechaPara ) {
          await prisma.evidenciaActividad.update({
            where: { id: element.id },
            data: { Estado: "A_TIEMPO" },
          });
          console.log("A_TIEMPO")
        }
      } else if (new Date() > Actividad.FechaPara ) {
        await prisma.evidenciaActividad.update({
          where: { id: element.id },
          data: { Estado: "ASTRASO" },
        });
        console.log("ASTRASO")

      }
    });
  }
}
