import 'dart:io';

import 'package:alumno/src/mainpage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'service/service_api.dart';

class EntregarEvidencia extends StatefulWidget {
  const EntregarEvidencia({super.key});

  @override
  State<EntregarEvidencia> createState() => _EntregarEvidenciaState();
}

class _EntregarEvidenciaState extends State<EntregarEvidencia> {
  final _cliete = ApiService();
  final _formKey = GlobalKey<FormState>();

  final _titulo = TextEditingController();
  final _descripcion = TextEditingController();
  final _fileName = TextEditingController();

  final _inputPadding = const EdgeInsets.symmetric(horizontal: 15, vertical: 5);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Entregar evidencia"))),
      body: Contenedor(
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
                controller: _fileName,
                readOnly: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'archivo',
                    hintText: 'Haz Click para seleccionar un archvivo'),
                onTap: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();

                  if (result != null) {
                    File file = File(result.files.single.path ?? "");
                    setState(() {
                      _fileName.text = file.path;
                    });
                  } else {
                    // User canceled the picker
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.

                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      )),
    );
  }
}
