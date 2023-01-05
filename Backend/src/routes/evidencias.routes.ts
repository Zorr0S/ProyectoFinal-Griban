import { Router } from "express";
import {
  changeCal,
  GetAlumosEvidence,
} from "../controllers/evidencias.controller";

const router = Router();

router.get("/Evidencias/:IDActividad", GetAlumosEvidence);
router.patch("/Evidencias/cambiarCalificacion/:IDActividad", changeCal);

//Actividades

export default router;
