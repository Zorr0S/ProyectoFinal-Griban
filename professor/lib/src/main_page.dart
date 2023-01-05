import 'package:flutter/material.dart';

import 'actividades/activadades_crud_page.dart';
import 'service/service_api.dart';
import 'tabla_asistencias.dart';
import 'tabla_final.dart';

class MainHub extends StatefulWidget {
  const MainHub({super.key});

  @override
  State<MainHub> createState() => _MainHubState();
}

class _MainHubState extends State<MainHub> {
  final _cliente = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Menu")),
        automaticallyImplyLeading: false,
      ),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ActividadesCrudPage()));
                },
                child: const Text("Actividades")),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Expanded(
              child: ElevatedButton(
                  onPressed: () async {
                    await _cliente.tomarAsistenciaHoy();
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const TablaAsistencias()));
                    });
                  },
                  child: const Text("Tomar Asistencia")),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                  width: 100,
                  child: Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const TablaFinalPage()));
                          });
                        },
                        child: const Text("Tabla final")),
                  )),
            ],
          )
        ],
      )),
    );
  }
}
