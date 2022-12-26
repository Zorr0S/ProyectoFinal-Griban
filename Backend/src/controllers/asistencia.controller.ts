import express, { Request, Response } from "express";
import { Prisma, PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

export async function CrearAsistenciaHoy(req: Request, res: Response) {
  try {
    const { PeriodoID } = req.params;
    const CurrentDate = new Date();
    //Fecha de hoy sin horas
    const CurrentDay = new Date(
      CurrentDate.getFullYear(),
      CurrentDate.getMonth(),
      CurrentDate.getDay()
    );

    const Existencia = await prisma.asistencias.findMany({
      where: { Fecha: { lte: CurrentDay, gte: CurrentDay } },
    });
    if (Existencia.length >= 1) {
      return res.json(Existencia);
    }

    const Alumnos = await prisma.users.findMany({ where: { Rol: "ALUMNO" } });
    //Crea todas las asistencias de hoy la deja con falta por default
    const asistencia = await prisma.asistencias.createMany({
      data: Alumnos.map(({ id }) => ({
        Fecha: CurrentDay,
        AlumnoID: id,
        RegistroID: 3,
        PeriodoID: parseInt(PeriodoID),
      })),
    });
    
    return res.json(asistencia);
  } catch (error) {
    console.error(error);
    return res
      .status(500)
      .json({ status: "ERROR", mensaje: "Contrasena incorrecta" });
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
