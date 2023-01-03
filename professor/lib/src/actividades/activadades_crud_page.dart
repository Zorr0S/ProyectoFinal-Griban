import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:professor/src/actividades/actividad_edit.dart';
import 'package:professor/src/service/api_classes.dart';
import 'package:professor/src/service/service_api.dart';

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
    return Scaffold(
        appBar: AppBar(title: const Text("ABC Actividades")),
        body: SingleChildScrollView(
          child: Column(children: [
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
          ]),
        ));
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
    return Container(
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
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: _inputPadding,
              child: TextFormField(
                controller: _titulo,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Titulo',
                    hintText: 'Titulo de actividad'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Rellene este campo';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: _inputPadding,
              child: TextFormField(
                controller: _descripcion,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Descripcion',
                    hintText: 'Intrucciones de la activadad'),
              ),
            ),
            Padding(
              padding: _inputPadding,
              child: TextFormField(
                controller: dateController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.calendar_today),
                    labelText: "Fecha de entrega"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Rellene este campo';
                  }
                  return null;
                },
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), //get today's date
                      firstDate: DateTime(
                          2000), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101));

                  if (pickedDate != null) {
                    //get the picked date in the format => 2022-07-04 00:00:00.000
                    String formattedDate = DateFormat('yyyy-MM-dd').format(
                        pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                    //formatted date output using intl package =>  2022-07-04
                    //You can format date as per your need

                    setState(() {
                      dateController.text =
                          formattedDate; //set foratted date to TextField value.
                    });
                  } else {
                    if (kDebugMode) {
                      print("Date is not selected");
                    }
                  }
                },
              ),
            ),
            Padding(
              padding: _inputPadding,
              child: DropdownButtonFormField(
                  items: listaTipoActividad
                      .map<DropdownMenuItem<TipoActividad>>(
                          (e) => DropdownMenuItem<TipoActividad>(
                                value: e,
                                child: Text(e.nombre),
                              ))
                      .toList(),
                  value: dPTipoActividad,
                  onChanged: ((value) {
                    setState(() {
                      dPTipoActividad = value!;
                    });
                  })),
            ),
            ElevatedButton(
              onPressed: () async {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  await _cliete.createActivdad(
                      dPTipoActividad.value,
                      _titulo.text,
                      _descripcion.text,
                      DateTime.parse(dateController.text));
                  widget.actividadCallback();
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
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
                          Text(
                              "Para: ${DateFormat('yyyy-MM-dd').format(_actividades[index].fechaPara).toString()}"),
                        ],
                      ),
                      subtitle: Text(_actividades[index].descripcion),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          child: const Text('Ver entrega'),
                          onPressed: () {/* ... */},
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          child: const Text('Editar'),
                          onPressed: () async {
                            bool refrescar = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => EditActividad(
                                          id: _actividades[index].id,
                                          titulo: _actividades[index].nombre,
                                          descripcion:
                                              _actividades[index].descripcion,
                                          fecha: DateFormat('yyyy-MM-dd')
                                              .format(_actividades[index]
                                                  .fechaPara),
                                          tipoActividad: listaTipoActividad
                                              .firstWhere((element) =>
                                                  element.value ==
                                                  _actividades[index].tipo),
                                          terminoEdicion: () {
                                            widget.onChange();
                                          },
                                        )));
                            if (refrescar) {
                              widget.onChange();
                              setState(() {
                                refrescar = false;
                              });
                            } else {
                              setState(() {
                                refrescar = false;
                              });
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          child: const Text('Eliminar'),
                          onPressed: () async {
                            if (await confirm(context,
                                title: const Text("Esta seguro?"),
                                content: const Text("Esto es permanente"))) {
                              await _cliete
                                  .eliminarActividad(_actividades[index].id);
                              widget.onChange();
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ))).toList());
  }
}
