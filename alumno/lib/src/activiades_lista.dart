import 'package:alumno/src/entregar_evidencia.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'service/api_classes.dart';
import 'service/service_api.dart';

class ActividadesCrudPage extends StatefulWidget {
  const ActividadesCrudPage({super.key});

  @override
  State<ActividadesCrudPage> createState() => _ActividadesCrudPageState();
}

class _ActividadesCrudPageState extends State<ActividadesCrudPage> {
  final _cliete = ApiService();
  late Future<List<Actividades>> _data;
  @override
  void initState() {
    actualizar();
    super.initState();
  }

  void actualizar() {
    _data = _cliete.getActividades();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CreateActivadad(
        actividadCallback: () {
          setState(() {
            _data = _cliete.getActividades();
          });
        },
      ),
      FutureBuilder(
        future: _data,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListaActividades(
              actividades: snapshot.data,
              onChange: () {
                setState(() {
                  actualizar();
                });
              },
            );
          } else {
            return Container();
          }
        },
      ),
    ]);
  }
}

class CreateActivadad extends StatefulWidget {
  final VoidCallback actividadCallback;

  const CreateActivadad({super.key, required this.actividadCallback});

  @override
  State<CreateActivadad> createState() => _CreateActivadadState();
}

class _CreateActivadadState extends State<CreateActivadad> {
  final _cliete = ApiService();
  final _formKey = GlobalKey<FormState>();

  final _titulo = TextEditingController();
  final _descripcion = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TipoActividad dPTipoActividad = listaTipoActividad.first;
  final _inputPadding = const EdgeInsets.symmetric(horizontal: 15, vertical: 5);

  @override
  void initState() {
    dateController.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ListaActividades extends StatefulWidget {
  final List<Actividades> actividades;
  final VoidCallback onChange;

  const ListaActividades(
      {super.key, required this.actividades, required this.onChange});

  @override
  State<ListaActividades> createState() => _ListaActividadesState();
}

class _ListaActividadesState extends State<ListaActividades> {
  List<Actividades> _actividades = [];
  final _cliete = ApiService();

  @override
  void initState() {
    super.initState();
    _actividades = widget.actividades;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: List.generate(
            _actividades.length,
            (index) => Card(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Chip(
                          label: Text(listaTipoActividad
                              .firstWhere((element) =>
                                  element.value == _actividades[index].tipo)
                              .nombre)),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_actividades[index].nombre),
                          Row(
                            children: [
                              EstadoEvidenciaChip(
                                  estado:
                                      _actividades[index].evidencia!.estado),
                              Text(
                                  "Para: ${DateFormat('yyyy-MM-dd').format(_actividades[index].fechaPara).toString()}"),
                            ],
                          ),
                        ],
                      ),
                      subtitle:
                          Center(child: Text(_actividades[index].descripcion)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              var uax = Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => EntregarEvidencia(
                                            idActivadad: _actividades[index].id,
                                          )));

                              widget.onChange();
                            },
                            child: const Text('Entregar'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ))).toList());
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
