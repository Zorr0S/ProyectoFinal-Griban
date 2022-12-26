import express, { Request, Response } from "express";
import { Prisma, PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

export async function Login(req: Request, res: Response) {
  try {
    const { User, Password } = req.body;
    if (User == undefined || Password == undefined)
      throw { msg: "Campos vacios" };
    const Login = await prisma.users.findFirstOrThrow({
      where: { AND: [{ UserName: User }, { Contrasena: Password }] },
      select: { id: true, UserName: true },
    });
    res.json(Login);
  } catch (error) {
    console.error(error);
    res
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
