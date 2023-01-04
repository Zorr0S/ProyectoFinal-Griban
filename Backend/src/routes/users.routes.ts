import { Router } from "express";
import { Login, LoginProfesor, Register } from "../controllers/users.controller";

const router = Router();
router.post("/login",Login)
router.post("/loginMaestro",LoginProfesor)

router.post("/register",Register)
export default router;
