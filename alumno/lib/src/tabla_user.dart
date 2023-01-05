import 'package:flutter/material.dart';

import 'service/api_classes.dart';
import 'service/service_api.dart';
import 'package:alumno/global.dart' as global;

class TablaDatosUser extends StatefulWidget {
  const TablaDatosUser({super.key});

  @override
  State<TablaDatosUser> createState() => _TablaDatosUserState();
}

class _TablaDatosUserState extends State<TablaDatosUser> {
  final _cliente = ApiService();
  late Future<ResumenUser> _data;
  @override
  void initState() {
    _data = _cliente.userDataByID(global.idUSer);

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

  List<DataRow> _createRows(ResumenUser datos) {
    return [
      DataRow(cells: [
        DataCell(Text(datos.nombre)),
        DataCell(
            Center(child: Text(datos.valorExamen.toStringAsFixed(2)))), //Examen
        DataCell(Center(
            child: Text(datos.portaFolio.toStringAsFixed(2)))), //Portafolio
        DataCell(Center(
            child: Text(datos.actividadCom.toStringAsFixed(2)))), //Asistencia
        DataCell(Center(child: Text(datos.total.toStringAsFixed(2)))),
        DataCell(Center(child: Text(boolToSiNo(datos.enRiesgo)))),
        DataCell(Center(child: Text(boolToSiNo(datos.excento))))
      ])
    ];
  }

//snapshot.data ??
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _data,
      builder: (BuildContext context, AsyncSnapshot<ResumenUser> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return DataTable(
              columns: _createColumn(),
              rows: _createRows(snapshot.data ??
                  ResumenUser(
                      nombre: "nombre",
                      valorExamen: 0,
                      portaFolio: 0,
                      actividadCom: 0,
                      actividadesEntregadas: 0,
                      asistencia: 0,
                      enRiesgo: true,
                      excento: true,
                      total: 0)));
        } else {
          return Container();
        }
      },
    );
  }
}
