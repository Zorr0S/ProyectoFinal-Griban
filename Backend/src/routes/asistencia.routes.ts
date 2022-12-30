import { Router } from "express";
import { CambiarRegistroAsistencia, CrearAsistenciaHoy, GetAsistencia } from "../controllers/asistencia.controller";

const router = Router();
router.get("/TomarAsistenciaHoy/:PeriodoID",CrearAsistenciaHoy)
router.get("/Asistencia",GetAsistencia)
router.patch("/Asistencia/:PeriodoID/cambiar/:AsistenciaID",CambiarRegistroAsistencia)

export default router;
