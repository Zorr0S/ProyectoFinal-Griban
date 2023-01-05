import 'package:flutter/material.dart';

class EntregarEvidencia extends StatefulWidget {
  const EntregarEvidencia({super.key});

  @override
  State<EntregarEvidencia> createState() => _EntregarEvidenciaState();
}

class _EntregarEvidenciaState extends State<EntregarEvidencia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("ABC Actividades"))),
      body: Center(child: Text("a")),
    );
  }
}
