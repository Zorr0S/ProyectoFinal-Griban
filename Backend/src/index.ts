import express, { Request, Response } from "express";
import cors from "cors";
import UsersRoutes from "./routes/users.routes"
import AsistenciaRoutes from './routes/asistencia.routes'
import ActivadesRoutes from './routes/actividades.routes'
import EvidenciasRoutes from "./routes/evidencias.routes"

const app = express();
app.use(express.json()); // application/json
app.use(express.static("public"));
app.use(cors());


app.use("/Users", UsersRoutes);
app.use("/Asistencia",AsistenciaRoutes );
app.use("/Actividad",ActivadesRoutes );
app.use("/Evidencia",EvidenciasRoutes );


app.listen(3000, function () {
    console.log("Servidor corriendo");
  });
