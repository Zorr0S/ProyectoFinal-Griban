import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:professor/src/service/api_classes.dart';

import 'service/service_api.dart';

class TablaAsistencias extends StatefulWidget {
  const TablaAsistencias({super.key});

  @override
  State<TablaAsistencias> createState() => _TablaAsistenciasState();
}

class _TablaAsistenciasState extends State<TablaAsistencias> {
  final _cliente = ApiService();
  late Future<List<Alumnos>> _data;

  List<DataCell> _createCeldasFecha(List<Asistencia> fechas, int idUser) {
    return List.generate(
        fechas.length,
        (index) => DataCell(AsistenciaDropDown(
              value: fechas[index],
              asistenciaChanged: () {
                _data = _cliente.getAsistencias();
                setState(() {});
              },
            )));
  }

  List<DataColumn> _createFechaColumns(List<Asistencia> fechas) {
    return List.generate(
        fechas.length,
        (index) => DataColumn(
              label: Expanded(
                child: Text(
                  DateFormat('yyyy-MM-dd')
                      .format(fechas[index].fecha)
                      .toString(),
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ));
  }

  List<DataRow> _createRows(List<Alumnos> datos) {
    return List.generate(
        datos.length,
        (index) => DataRow(
            cells: [
                  DataCell(Text(datos[index].nombre)),
                ] +
                _createCeldasFecha(datos[index].asistencia, index) +
                [
                  DataCell(Text(_porcentajeAsistencia(datos[index].asistencia)
                      .toStringAsFixed(2)))
                ]));
  }

  int _getRetrasos(List<Asistencia> asistencia) {
    var retrasos =
        asistencia.where((element) => element.registro.letra == "R").toList();
    var asistencias =
        asistencia.where((element) => element.registro.letra == "A").toList();
    var justificacion =
        asistencia.where((element) => element.registro.letra == "J").toList();
    var Faltas =
        asistencia.where((element) => element.registro.letra == "A").toList();
    var valorRetrasos = (retrasos.length / 3).truncate();
    var valorRetrasosPositivos = (retrasos.length % 3);

    return asistencias.length +
        justificacion.length -
        valorRetrasos +
        valorRetrasosPositivos;
  }

  double _porcentajeAsistencia(List<Asistencia> asistencia) {
    var puntos = _getRetrasos(asistencia);

    return (puntos / asistencia.length) * 100;
  }

  @override
  initState() {
    _data = _cliente.getAsistencias();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Asistencias")),
        body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: _data,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Center(
                        child: DataTable(
                            columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Nombre',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                ] +
                                _createFechaColumns(
                                    snapshot.data[0].asistencia) +
                                [
                                  const DataColumn(
                                    label: Expanded(
                                      child: Text(
                                        'Asistencia',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  )
                                ],
                            rows: _createRows(snapshot.data)),
                      );
                    } else {
                      return const Text("Cargando");
                    }
                  },
                ),
              ],
            )));
  }
}

class AsistenciaDropDown extends StatefulWidget {
  final Asistencia value;
  final VoidCallback asistenciaChanged;
  const AsistenciaDropDown(
      {super.key, required this.value, required this.asistenciaChanged});

  @override
  State<AsistenciaDropDown> createState() => _AsistenciaDropDownState();
}

class _AsistenciaDropDownState extends State<AsistenciaDropDown> {
  Registro dropdownValue = opcionesRegistro.first;
  final _cliente = ApiService();

  @override
  void initState() {
    super.initState();
    dropdownValue = opcionesRegistro
        .firstWhere((element) => element.letra == widget.value.registro.letra);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        items: opcionesRegistro
            .map<DropdownMenuItem<Registro>>((e) => DropdownMenuItem<Registro>(
                  value: e,
                  child: Text(e.descripcion),
                ))
            .toList(),
        value: dropdownValue,
        onChanged: (e) async {
          // ignore: unused_local_variable
          var aux =
              await _cliente.changeAsistenciaAlumno(1, widget.value.id, e!.id);
          setState(() {
            dropdownValue = e;
          });
          widget.asistenciaChanged();
        });
  }
}
