import express, { Request, Response } from "express";
import cors from "cors";
import UsersRoutes from "./routes/users.routes"

const app = express();
app.use(express.json()); // application/json
app.use(express.static("public"));
app.use(cors());


app.use("/users", UsersRoutes);
app.use("/asistencia", );


app.listen(3000, function () {
    console.log("Servidor corriendo");
  });