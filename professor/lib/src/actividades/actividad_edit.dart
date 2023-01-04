import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../service/api_classes.dart';
import '../service/service_api.dart';

class EditActividad extends StatefulWidget {
  final int id;
  final String titulo;
  final String descripcion;
  final String fecha;
  final TipoActividad tipoActividad;
  final VoidCallback terminoEdicion;
  const EditActividad({
    super.key,
    required this.titulo,
    required this.id,
    required this.descripcion,
    required this.fecha,
    required this.tipoActividad,
    required this.terminoEdicion,
  });

  @override
  State<EditActividad> createState() => _EditActividadState();
}

class _EditActividadState extends State<EditActividad> {
  final _cliete = ApiService();
  final _formKey = GlobalKey<FormState>();

  final _titulo = TextEditingController();
  final _descripcion = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TipoActividad dPTipoActividad = listaTipoActividad.first;
  final _inputPadding = const EdgeInsets.symmetric(horizontal: 15, vertical: 5);
  @override
  void initState() {
    super.initState();
    _titulo.text = widget.titulo;
    _descripcion.text = widget.descripcion;
    dateController.text = widget.fecha;
    dPTipoActividad = widget.tipoActividad;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Activadad"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
      body: Container(
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
                    var aux = await _cliete.updateActivdad(
                        widget.id,
                        dPTipoActividad.value,
                        _titulo.text,
                        _descripcion.text,
                        DateTime.parse(dateController.text));
                    setState(() {
                      if (aux) {
                        widget.terminoEdicion();
                        Navigator.pop(context, true);
                      } else {
                        const SnackBar(content: Text("Ocurrio un error"));
                      }
                    });
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
