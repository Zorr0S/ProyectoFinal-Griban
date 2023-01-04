import { Router } from "express";
import {
  GetAlumosEvidence,
} from "../controllers/evidencias.controller";

const router = Router();

router.get("/Evidencias/:IDActividad", GetAlumosEvidence);
//Actividades

export default router;
