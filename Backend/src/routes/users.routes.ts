import { Router } from "express";
import { getDatosUser, Login, LoginProfesor, Register } from "../controllers/users.controller";

const router = Router();
router.post("/login",Login)
router.post("/loginMaestro",LoginProfesor)

router.post("/register",Register)
router.get("/datosUser",getDatosUser)

export default router;
