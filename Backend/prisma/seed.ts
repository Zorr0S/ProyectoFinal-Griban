import { addMonths } from "date-fns";
import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

async function main() {
  const user = await prisma.users.createMany({
    data: [
      {
        Nombre: "Profesor",
        UserName: "Profesor",
        Contrasena: "Contra",
        Rol: "PROFESOR",
      },
      {
        Nombre: "Alumno",
        UserName: "Alumno",
        Contrasena: "Contra",
        Rol: "ALUMNO",
      },
      {
        Nombre: "Alumno2",
        UserName: "Alumno2",
        Contrasena: "Contra",
        Rol: "ALUMNO",
      },
      {
        Nombre: "Alumno3",
        UserName: "Alumno3",
        Contrasena: "Contra",
        Rol: "ALUMNO",
      },
    ],
  });
  const FechaInicical = new Date(2022, 12, 1);
  const FechaFinal = addMonths(FechaInicical, 3);
  const Period = await prisma.periodo.create({
    data: {
      Nombre: "Periodo - 1",
      FechaInicio: FechaInicical,
      FechaFinal: FechaFinal,
    },
  });

  const RegistroAsistencia = await prisma.registroAsistencia.createMany({
    data: [
      { Valor: 1, Letra: "A", Descripcion: "Asistencia", PeriodoID: Period.id }, // 1
      {
        Valor: 1,
        Letra: "J",
        Descripcion: "Justificacion",
        PeriodoID: Period.id,
      }, // 2
      { Valor: 0, Letra: "F", Descripcion: "Falta", PeriodoID: Period.id }, // 3
      { Valor: 0, Letra: "R", Descripcion: "Retardo", PeriodoID: Period.id }, // 4
    ],
  });
  
}
main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
