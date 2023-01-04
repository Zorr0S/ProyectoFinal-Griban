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
      include: { Alumno: { select: { Nombre: true } } },
    });

    evidencia.forEach(async (element) => {
      if (element.FechaSubida != null) {
        if (element.FechaSubida > Actividad.FechaPara) {
          await prisma.evidenciaActividad.update({
            where: { id: element.id },
            data: { Estado: "ASTRASO" },
          });
        } else if ( Actividad.FechaPara <element.FechaSubida) {
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
