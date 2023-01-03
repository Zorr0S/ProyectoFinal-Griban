import { Router } from "express";
import { CreateActividad, getActividades } from "../controllers/actividades.controller";

const router = Router();
router.get("/Actividades",getActividades)
router.post("/CREAR/actividad", CreateActividad)

export default router;
