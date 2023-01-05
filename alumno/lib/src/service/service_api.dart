// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import 'api_classes.dart';
import 'package:alumno/global.dart' as global;

class ApiService {
  final String domain = "localhost";
  final int port = 3000;
  var headers = {
    'Content-Type': 'application/json',
  };
  BaseOptions options2 = BaseOptions(
    baseUrl: "http://localhost:3000",
    connectTimeout: 3000,
    receiveTimeout: 3000,
  );
  var dio = Dio();
  ApiService() {
    dio.options = options2;
  }
  /////////////////////////////////////////////////////////
  Future<bool> loginProfesor(String user, String pass) async {
    //var url = Uri.http('$domain:$port', '/Users/login');
    try {
      final response = await dio.post("/Users/loginMaestro",
          data: {"User": user, "Password": pass},
          options: Options(
              headers: {HttpHeaders.contentTypeHeader: "application/json"}));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> loginAlumno(String user, String pass) async {
    //var url = Uri.http('$domain:$port', '/Users/login');
    try {
      final response = await dio.post("/Users/loginAlumno",
          data: {"User": user, "Password": pass},
          options: Options(
              headers: {HttpHeaders.contentTypeHeader: "application/json"}));
      if (response.statusCode == 200) {
        global.idUSer = response.data["id"];
        global.nombre = response.data["UserName"];

        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> login(String user, String pass) async {
    //var url = Uri.http('$domain:$port', '/Users/login');
    try {
      final response = await dio.post("/Users/loginMaestro",
          data: {"User": user, "Password": pass},
          options: Options(
              headers: {HttpHeaders.contentTypeHeader: "application/json"}));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Alumnos>> getAsistencias() async {
    // var url = Uri.http('$domain:$port', '/Asistencia/Asistencia');
    List<Alumnos> listaAsistencias;

    try {
      final response = await dio.get('/Asistencia/Asistencia');

      if (response.statusCode == 200) {
        final List t = response.data;
        listaAsistencias = t.map((item) => Alumnos.fromJson(item)).toList();
        return listaAsistencias;
      }
      return listaAsistencias = [];
    } on Exception catch (e) {
      print(e);
      return listaAsistencias = [];
    }
  }

  Future<List<ResumenUser>> userData() async {
    // var url = Uri.http('$domain:$port', '/Asistencia/Asistencia');
    List<ResumenUser> listaAsistencias;

    try {
      final response = await dio.get('/users/datosUser');

      if (response.statusCode == 200) {
        final List t = response.data;
        listaAsistencias = t.map((item) => ResumenUser.fromJson(item)).toList();
        return listaAsistencias;
      }
      return listaAsistencias = [];
    } on Exception catch (e) {
      print(e);
      return listaAsistencias = [];
    }
  }

  Future<ResumenUser> userDataByID(int idUser) async {
    // var url = Uri.http('$domain:$port', '/Asistencia/Asistencia');
    var aux = ResumenUser(
        nombre: "nombre",
        valorExamen: 0,
        portaFolio: 0,
        actividadCom: 0,
        actividadesEntregadas: 0,
        asistencia: 0,
        enRiesgo: true,
        excento: true,
        total: 0);
    try {
      final response = await dio.get('/Users/datoUser/$idUser');

      if (response.statusCode == 200) {
        return ResumenUser.fromJson(response.data);
      }
      return aux;
    } on Exception catch (e) {
      print(e);
      return aux;
    }
  }

  Future changeAsistenciaAlumno(
      int periodoID, int asistenciaID, int valor) async {
    try {
      // var url = Uri.http('$domain:$port',
      //     '/Asistencia/Asistencia/$periodoID/cambiar/$asistenciaID');
      // var data = {"Registro": valor};
      // var body = json.encode(data);
      final response = await dio.patch(
          '/Asistencia/Asistencia/$periodoID/cambiar/$asistenciaID',
          options: Options(
              headers: {HttpHeaders.contentTypeHeader: "application/json"}),
          data: {"Registro": valor});
      if (response.statusCode == 200) {
        return response.data;
      }
      return response.data;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

// activity related
  Future<List<Actividades>> getActividades() async {
    List<Actividades> listaActividades = [];
    try {
      final response = await dio.get("/Actividad/Actividades");
      if (response.statusCode == 200) {
        final List t = response.data;
        listaActividades = t.map((item) => Actividades.fromJson(item)).toList();
        return listaActividades;
      }
      return listaActividades;
    } on Exception catch (e) {
      print(e);
      return listaActividades;
    }
  }

  Future<bool> createActivdad(
    String tipo,
    String nombre,
    String description,
    DateTime fecha,
  ) async {
    try {
      final response = await dio.post("/Actividad/CREAR/actividad", data: {
        "Tipo": tipo,
        "Nombre": nombre,
        "Descripcion": description,
        "FechaFinal": fecha.toIso8601String()
      });
      if (response.statusCode == 200) {
        return true;
      }
      print(response.statusCode);
      return false;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateActivdad(
    int id,
    String tipo,
    String nombre,
    String description,
    DateTime fecha,
  ) async {
    try {
      final response =
          await dio.patch("/Actividad/EDITAR/actividad/$id", data: {
        "Tipo": tipo,
        "Nombre": nombre,
        "Descripcion": description,
        "FechaFinal": fecha.toIso8601String()
      });
      if (response.statusCode == 200) {
        return true;
      }
      print(response.statusCode);
      return false;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<EvidenciaAlumnos>> getActivityEvidence(
    int id,
  ) async {
    List<EvidenciaAlumnos> lista = [];
    try {
      final response = await dio.get("/Evidencia/Evidencias/$id");
      if (response.statusCode == 200) {
        final List t = response.data;
        lista = t.map((item) => EvidenciaAlumnos.fromJson(item)).toList();
        return lista;
      }
      print(response.statusCode);
      return lista;
    } on Exception catch (e) {
      print(e);
      return lista;
    }
  }

  ///Asistencia/TomarAsistenciaHoy/1
  Future<bool> eliminarActividad(int id) async {
    try {
      final response = await dio.delete("/Actividad/BORRAR/actividad/$id");
      if (response.statusCode == 200) {
        return true;
      }
      print(response.statusCode);
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> tomarAsistenciaHoy() async {
    try {
      final response = await dio.get("/Asistencia/TomarAsistenciaHoy/1");
      if (response.statusCode == 200) {
        return true;
      }
      print(response.statusCode);
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> cambiarCalificacion(int idEvidencia, int idCal) async {
    try {
      final response = await dio.patch(
          "/Evidencia/Evidencias/cambiarCalificacion/$idEvidencia",
          data: {"CalificacionID": idCal});
      if (response.statusCode == 200) {
        return true;
      }
      print(response.statusCode);
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
