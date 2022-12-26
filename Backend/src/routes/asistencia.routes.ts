import { Router } from "express";
import { Login, Register } from "../controllers/users.controller";

const router = Router();
router.get("/login",Login)
router.post("/register",Register)
export default router;
