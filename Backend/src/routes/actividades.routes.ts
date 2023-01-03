import { Router } from "express";
import { CreateActividad, EliminarActividad, getActividades, UpdateActividad } from "../controllers/actividades.controller";

const router = Router();
router.get("/Actividades",getActividades)
router.post("/CREAR/actividad", CreateActividad)
router.patch("/EDITAR/actividad/:IDActividad", UpdateActividad)
router.delete("/BORRAR/actividad/:IDActividad", EliminarActividad)



export default router;
