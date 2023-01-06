// ignore_for_file: avoid_print

class Alumnos {
  final String nombre;
  final List<Asistencia> asistencia;
  List<EvidenciaAlumnos> evidencias;
  Alumnos(
      {required this.nombre,
      required this.asistencia,
      this.evidencias = const []});

  factory Alumnos.fromJson(Map<String, dynamic> jsonData) {
    var list = jsonData['Asistencias'] as List;
    List<Asistencia> asistList =
        list.map((i) => Asistencia.fromJson(i)).toList();

    return Alumnos(nombre: jsonData['Nombre'], asistencia: asistList);
  }
  getLit(Map<String, dynamic> jsonData) {
    return jsonData;
  }
}

class DatosAlumnos {
  final String nombre;
  final List<Asistencia> asistencia;
  List<Evidencia> evidencias;
  DatosAlumnos(
      {required this.nombre,
      required this.asistencia,
      this.evidencias = const []});

  factory DatosAlumnos.fromJson(Map<String, dynamic> jsonData) {
    var list = jsonData['Asistencias'] as List;
    List<Asistencia> asistList =
        list.map((i) => Asistencia.fromJson(i)).toList();
    var list2 = jsonData['EvidenciaActividad'] as List;
    List<Evidencia> evidenceList =
        list2.map((i) => Evidencia.fromJson(i)).toList();

    return DatosAlumnos(
        nombre: jsonData['Nombre'],
        asistencia: asistList,
        evidencias: evidenceList);
  }
  getLit(Map<String, dynamic> jsonData) {
    return jsonData;
  }
}

class Asistencia {
  final int id;
  final DateTime fecha;
  final int registroID;

  final int periodoID;
  final Registro registro;
  const Asistencia({
    required this.id,
    required this.fecha,
    required this.periodoID,
    required this.registroID,
    required this.registro,
  });
  factory Asistencia.fromJson(Map<String, dynamic> jsonData) {
    return Asistencia(
        id: jsonData["id"],
        fecha: DateTime.parse(jsonData["Fecha"]),
        registroID: jsonData['RegistroID'],
        periodoID: jsonData["PeriodoID"],
        registro: Registro.fromJson(jsonData["Registro"]));
  }
}

class Registro {
  final int id;
  final String letra;
  final String descripcion;
  final int valor;
  final int periodoID;

  const Registro(
      {required this.id,
      required this.letra,
      required this.descripcion,
      required this.valor,
      required this.periodoID});

  factory Registro.fromJson(Map<String, dynamic> json) {
    return Registro(
        id: json['id'],
        letra: json["Letra"],
        descripcion: json["Descripcion"],
        valor: json["Valor"],
        periodoID: json["PeriodoID"]);
  }
}

String hola = "";
const List<Registro> opcionesRegistro = [
  Registro(
      id: 1, letra: "A", descripcion: "Asistencia", valor: 1, periodoID: 1),
  Registro(
      id: 2, letra: "J", descripcion: "Justificacion", valor: 1, periodoID: 1),
  Registro(id: 3, letra: "F", descripcion: "Falta", valor: 0, periodoID: 1),
  Registro(id: 4, letra: "R", descripcion: "Retardo", valor: 0, periodoID: 1),
];

class TipoActividad {
  String nombre;
  String value;
  TipoActividad({required this.nombre, required this.value});
}

class EstadoEvidencia {
  String nombre;
  String value;
  EstadoEvidencia({required this.nombre, required this.value});
}

List<TipoActividad> listaTipoActividad = [
  TipoActividad(value: "PORTAFOLIO", nombre: "Portafolio"),
  TipoActividad(
      value: "ACTIVIDADCOMPLEMENTARIA", nombre: "Actividad Complementaria"),
  TipoActividad(value: "EXAMEN", nombre: "Examen")
];

List<EstadoEvidencia> listaEstadoEvidencia = [
  EstadoEvidencia(nombre: "Sin entregar", value: "SIN_ENTREGAR"),
  EstadoEvidencia(nombre: "A tiempo", value: "A_TIEMPO"),
  EstadoEvidencia(nombre: "Atraso", value: "ASTRASO")
];

class Actividades {
  final int id;
  final String tipo;
  final String nombre;
  final String descripcion;
  final DateTime fechaSubida;
  final DateTime fechaPara;

  final Evidencia? evidencia;
  const Actividades(
      {required this.id,
      required this.tipo,
      required this.nombre,
      required this.descripcion,
      required this.fechaSubida,
      required this.fechaPara,
      required this.evidencia});

  factory Actividades.fromJson(Map<String, dynamic> json) {
    var list = json['EvidenciaActividad'] as List;
    List<Evidencia> evidenceList =
        list.map((i) => Evidencia.fromJson(i)).toList();

    return Actividades(
        id: json['id'],
        tipo: json["Tipo"],
        nombre: json["Nombre"],
        descripcion: json["Descripcion"],
        fechaSubida: DateTime.parse(json["FechaSubida"]),
        fechaPara: DateTime.parse(json["FechaPara"]),
        evidencia: evidenceList.first);
  }
}

class EvidenciaAlumnos {
  final int id;
  final int actividadID;
  final String nombre;
  final String? descripcion;
  final DateTime? fechaSubida;
  final int alumnoID;
  final Alumno alumno;
  final String? nombreArchivo;
  final String? evidenciaURL;
  final String estado;
  final Calificacion calificacion;
  final int calificacionId;

  EvidenciaAlumnos(
      {required this.id,
      required this.alumno,
      required this.alumnoID,
      required this.actividadID,
      required this.nombre,
      required this.descripcion,
      required this.fechaSubida,
      required this.nombreArchivo,
      required this.evidenciaURL,
      required this.estado,
      required this.calificacionId,
      required this.calificacion});
  factory EvidenciaAlumnos.fromJson(Map<String, dynamic> json) {
    return EvidenciaAlumnos(
        id: json['id'],
        actividadID: json["ActividadID"],
        nombre: json["Nombre"],
        descripcion: json["Descripcion"],
        fechaSubida: DateTime.parse(json["FechaSubida"]),
        alumnoID: json["AlumnoID"],
        nombreArchivo: json["NombreArchivo"],
        evidenciaURL: json["EvidenciaURL"],
        estado: json["Estado"],
        alumno: Alumno.fromJson(json["Alumno"]),
        calificacionId: json["CalificacionID"],
        calificacion: Calificacion.fromJson(json["Calificacion"] ??
            Calificacion(id: 8, letra: "asd", valor: 1)));
  }
}

class Alumno {
  final String nombre;
  Alumno({required this.nombre});
  factory Alumno.fromJson(Map<String, dynamic> json) {
    return Alumno(
      nombre: json["Nombre"],
    );
  }
}

class Calificacion {
  final int id;
  final String letra;
  final double valor;
  Calificacion({required this.id, required this.letra, required this.valor});

  factory Calificacion.fromJson(Map<String, dynamic> json) {
    return Calificacion(
        id: json['id'],
        letra: json['letra'],
        valor: double.parse(json["valor"]));
  }
}

List<Calificacion> listCalificaciones = [
  Calificacion(id: 1, letra: "F", valor: 5),
  Calificacion(id: 2, letra: "D", valor: 6),
  Calificacion(id: 3, letra: "C", valor: 7),
  Calificacion(id: 4, letra: "B", valor: 8),
  Calificacion(id: 5, letra: "A", valor: 10)
];

class Evidencia {
  final int id;
  final int actividadID;
  final String nombre;
  final String? descripcion;
  final DateTime? fechaSubida;
  final int alumnoID;
  final String? nombreArchivo;
  final String? evidenciaURL;
  final String estado;
  final Calificacion calificacion;

  Evidencia(
      {required this.id,
      required this.alumnoID,
      required this.actividadID,
      required this.nombre,
      required this.descripcion,
      required this.fechaSubida,
      required this.nombreArchivo,
      required this.evidenciaURL,
      required this.estado,
      required this.calificacion});
  factory Evidencia.fromJson(Map<String, dynamic> json) {
    return Evidencia(
        id: json['id'],
        actividadID: json["ActividadID"],
        nombre: json["Nombre"],
        descripcion: json["Descripcion"],
        fechaSubida: DateTime.parse(json["FechaSubida"]),
        alumnoID: json["AlumnoID"],
        nombreArchivo: json["NombreArchivo"],
        evidenciaURL: json["EvidenciaURL"],
        estado: json["Estado"],
        calificacion: Calificacion.fromJson(json["Calificacion"]));
  }
}

class ResumenUser {
  final String nombre;
  final double valorExamen;
  final double portaFolio;
  final double actividadCom;
  final double actividadesEntregadas;
  final double asistencia;
  final bool enRiesgo;
  final bool excento;
  final double total;
  ResumenUser(
      {required this.nombre,
      required this.valorExamen,
      required this.portaFolio,
      required this.actividadCom,
      required this.actividadesEntregadas,
      required this.asistencia,
      required this.enRiesgo,
      required this.excento,
      required this.total});

  factory ResumenUser.fromJson(Map<String, dynamic> json) {
    return ResumenUser(
        nombre: json["Nombre"],
        valorExamen: json["ValorExamen"].toDouble(),
        portaFolio: json["PortaFolio"].toDouble(),
        actividadCom: json["ActividadCom"].toDouble(),
        asistencia: json["Asistencia"].toDouble(),
        actividadesEntregadas: json["ActividadesEntregadas"].toDouble(),
        enRiesgo: json["EnRiesgo"],
        excento: json["Excento"],
        total: json["Total"].toDouble());
  }
}
