import { Router } from "express";
import {
  changeCal,
  EntregarEvidencia,
  GetAlumosEvidence,
} from "../controllers/evidencias.controller";

const router = Router();

router.get("/Evidencias/:IDActividad", GetAlumosEvidence);
router.patch("/Evidencias/cambiarCalificacion/:IDActividad", changeCal);
router.post("/Evidencias/entregar/:IDActividad", EntregarEvidencia);


//Actividades

export default router;
