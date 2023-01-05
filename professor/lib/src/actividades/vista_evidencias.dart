import 'package:flutter/material.dart';
import 'package:professor/src/service/api_classes.dart';
import 'package:url_launcher/url_launcher.dart';

import '../service/service_api.dart';
import 'cb_calififcacion.dart';

class VerEvidenciasAlumnos extends StatefulWidget {
  final int id;
  const VerEvidenciasAlumnos({super.key, required this.id});

  @override
  State<VerEvidenciasAlumnos> createState() => _VerEvidenciasAlumnosState();
}

class _VerEvidenciasAlumnosState extends State<VerEvidenciasAlumnos> {
  final _cliete = ApiService();
  late Future<List<EvidenciaAlumnos>> _data;
  @override
  void initState() {
    actualizar();

    super.initState();
  }

  void actualizar() {
    _data = _cliete.getActivityEvidence(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Evidencia de alumnos"))),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: FutureBuilder(
              future: _data,
              builder: (BuildContext context,
                  AsyncSnapshot<List<EvidenciaAlumnos>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: Chip(
                            label: Text(snapshot.data![index].alumno.nombre)),
                        title: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(snapshot.data![index].nombre),
                              EstadoEvidenciaChip(
                                estado: snapshot.data![index].estado,
                              ),
                              DropDowmCalificacion(
                                calificacion:
                                    snapshot.data![index].calificacion,
                                idEvidencia: snapshot.data![index].id,
                              )
                            ],
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text((snapshot.data![index].descripcion ?? "")),
                              ElevatedButton(
                                  onPressed: () async {
                                    if (snapshot.data![index].evidenciaURL !=
                                        null) {
                                      const url = 'https://flutter.io';
                                      final uri = Uri.parse(url);
                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(uri);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    }
                                  },
                                  child: const Text("Abrir"))
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EstadoEvidenciaChip extends StatelessWidget {
  final String estado;
  const EstadoEvidenciaChip({super.key, required this.estado});
  MaterialColor getColor() {
    // ignore: no_leading_underscores_for_local_identifiers
    var _estado =
        listaEstadoEvidencia.firstWhere((element) => element.value == estado);
    if (_estado.value == "SIN_ENTREGAR") {
      return Colors.yellow;
    }
    if (_estado.value == "A_TIEMPO") {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  EstadoEvidencia estadoEvidencia() {
    return listaEstadoEvidencia
        .firstWhere((element) => element.value == estado);
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
        label: Text(
          estadoEvidencia().nombre,
        ),
        backgroundColor: getColor());
  }
}
