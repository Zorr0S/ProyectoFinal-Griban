import 'package:flutter/material.dart';
import 'package:professor/src/service/api_classes.dart';

import '../service/service_api.dart';

class DropDowmCalificacion extends StatefulWidget {
  final int idEvidencia;

  final Calificacion calificacion;

  const DropDowmCalificacion(
      {super.key, required this.calificacion, required this.idEvidencia});

  @override
  State<DropDowmCalificacion> createState() => _DropDowmCalificacionState();
}

class _DropDowmCalificacionState extends State<DropDowmCalificacion> {
  Calificacion dropdownValue = listCalificaciones.first;
  final _cliente = ApiService();

  @override
  void initState() {
    dropdownValue = listCalificaciones
        .where((element) => element.id == widget.calificacion.id)
        .first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        value: dropdownValue,
        items: listCalificaciones
            .map<DropdownMenuItem<Calificacion>>(
                (e) => DropdownMenuItem<Calificacion>(
                      value: e,
                      child: Text(e.letra),
                    ))
            .toList(),
        onChanged: ((value) async {
          var aux =
              await _cliente.cambiarCalificacion(widget.idEvidencia, value!.id);
          setState(() {
            dropdownValue = value!;
          });
        }));
  }
}
