import 'package:flutter/material.dart';
import 'package:professor/src/service/api_classes.dart';

import 'service/service_api.dart';

class TablaFinalPage extends StatefulWidget {
  const TablaFinalPage({super.key});

  @override
  State<TablaFinalPage> createState() => _TablaFinalPageState();
}

class _TablaFinalPageState extends State<TablaFinalPage> {
  final _cliente = ApiService();
  late Future<List<ResumenUser>> _data;
  @override
  void initState() {
    _data = _cliente.userData();

    super.initState();
  }

  String boolToSiNo(bool dato) {
    if (dato) {
      return "Si";
    } else {
      return "No";
    }
  }

  List<DataColumn> _createColumn() {
    return [
      const DataColumn(
          label: Expanded(
        child: Text("Nombre"),
      )),
      DataColumn(
        label: Expanded(
          child: Column(
            children: const [
              Text("Examen"),
              Text("40 %"),
            ],
          ),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Column(
            children: const [
              Text("Portafolio de evidencias"),
              Text("40 %"),
            ],
          ),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Column(
            children: const [
              Text("Activiadad Complementaria"),
              Text("20 %"),
            ],
          ),
        ),
      ),
      const DataColumn(
        label: Expanded(
          child: Text("Total"),
        ),
      ),
      const DataColumn(
        label: Expanded(
          child: Text("En riesgo?"),
        ),
      ),
      const DataColumn(
        label: Expanded(
          child: Text("Excento?"),
        ),
      ),
    ];
  }

  // double _getExamenes(List<Evidencia> data) {
  //   var cantidad = data.length;
  //   var aux = data.map((e) => e.calificacion);
  // }

  List<DataRow> _createRows(List<ResumenUser> datos) {
    return List.generate(
        datos.length,
        (index) => DataRow(cells: [
              DataCell(Text(datos[index].nombre)),
              DataCell(Center(
                  child: Text(
                      datos[index].valorExamen.toStringAsFixed(2)))), //Examen
              DataCell(Center(
                  child: Text(datos[index]
                      .portaFolio
                      .toStringAsFixed(2)))), //Portafolio
              DataCell(Center(
                  child: Text(datos[index]
                      .actividadCom
                      .toStringAsFixed(2)))), //Asistencia
              DataCell(
                  Center(child: Text(datos[index].total.toStringAsFixed(2)))),
              DataCell(Center(child: Text(boolToSiNo(datos[index].enRiesgo)))),
              DataCell(Center(child: Text(boolToSiNo(datos[index].excento))))
            ]));
  }

//snapshot.data ??
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Resumen de alumnos"))),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: _data,
              builder: (BuildContext context,
                  AsyncSnapshot<List<ResumenUser>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return DataTable(
                      columns: _createColumn(),
                      rows: _createRows(snapshot.data ?? []));
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
