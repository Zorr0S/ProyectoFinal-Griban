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
  late Future<List<DatosAlumnos>> _data;
  @override
  void initState() {
    _data = _cliente.userData();

    super.initState();
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
              Text("Portafolio de evidencias"),
              Text("20 %"),
            ],
          ),
        ),
      ),
    ];
  }

  List<DataRow> _createRows(List<DatosAlumnos> datos) {
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: _data,
              builder: (BuildContext context,
                  AsyncSnapshot<List<DatosAlumnos>> snapshot) {
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
