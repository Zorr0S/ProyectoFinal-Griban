import { Router } from "express";
import {
  changeCal,
  GetAlumosEvidence,
} from "../controllers/evidencias.controller";

const router = Router();

router.get("/Evidencias/:IDActividad", GetAlumosEvidence);
router.patch("/Evidencias/cambiarCalificacion/:IDActividad", changeCal);
router.post("/Evidencias/entregar/:IDActividad", changeCal);


//Actividades

export default router;
