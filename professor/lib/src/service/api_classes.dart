// ignore_for_file: avoid_print

class Alumnos {
  final String nombre;
  final List<Asistencia> asistencia;
  const Alumnos({required this.nombre, required this.asistencia});
  factory Alumnos.fromJson(Map<String, dynamic> jsonData) {
    var list = jsonData['Asistencias'] as List;
    print(list.runtimeType); //returns List<dynamic>
    List<Asistencia> asistList =
        list.map((i) => Asistencia.fromJson(i)).toList();
    //var aux2 = aux.map((item) => Alumnos.fromJson(item)).toList();
    print(asistList);

    return Alumnos(nombre: jsonData['Nombre'], asistencia: asistList);
  }
  getLit(Map<String, dynamic> jsonData) {
    return jsonData;
  }
  // gethola(Map<String, dynamic> jsonData) {
  //   var aux =jsonData.map((key, value) => null)
  //   Map((item) => Alumnos.fromJson(item)).toList();
  // }
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

  const Actividades({
    required this.id,
    required this.tipo,
    required this.nombre,
    required this.descripcion,
    required this.fechaSubida,
    required this.fechaPara,
  });

  factory Actividades.fromJson(Map<String, dynamic> json) {
    return Actividades(
        id: json['id'],
        tipo: json["Tipo"],
        nombre: json["Nombre"],
        descripcion: json["Descripcion"],
        fechaSubida: DateTime.parse(json["FechaSubida"]),
        fechaPara: DateTime.parse(json["FechaPara"]));
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

  EvidenciaAlumnos({
    required this.id,
    required this.alumno,
    required this.alumnoID,
    required this.actividadID,
    required this.nombre,
    required this.descripcion,
    required this.fechaSubida,
    required this.nombreArchivo,
    required this.evidenciaURL,
    required this.estado,
  });
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
        alumno: Alumno.fromJson(json["Alumno"]));
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
