import { Router } from "express";
import { getDatosUser, getDatoUserbyID, Login, LoginProfesor, Register } from "../controllers/users.controller";

const router = Router();
router.post("/loginAlumno",Login)
router.post("/loginMaestro",LoginProfesor)

router.post("/register",Register)
router.get("/datosUser",getDatosUser)
router.get("/datoUser/:IDUser",getDatoUserbyID)


export default router;
