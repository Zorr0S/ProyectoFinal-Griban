import { Router } from "express";
import { Login, Register } from "../controllers/users.controller";

const router = Router();
router.post("/login",Login)
router.post("/loginMaestro",Login)

router.post("/register",Register)
export default router;
