import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'api_classes.dart';

class ApiService {
  final String domain = "localhost";
  final int port = 3000;
  var headers = {
    'Content-Type': 'application/json',
  };
  /////////////////////////////////////////////////////////
  Future<bool> login(String user, String pass) async {
    var url = Uri.http('$domain:$port', '/Users/login');
    final response = await http.post(url,
        headers: headers, body: jsonEncode({"User": user, "Password": pass}));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Alumnos>> getAsistencias() async {
    var url = Uri.http('$domain:$port', '/Asistencia/Asistencia');
    final response = await http.get(url);
    print(url.toString());
    List<Alumnos> listaAsistencias;

    if (response.statusCode == 200) {
      final List t = json.decode(response.body);
      // ignore: avoid_print
      listaAsistencias = t.map((item) => Alumnos.fromJson(item)).toList();
      return listaAsistencias;
    }
    return listaAsistencias = [];
  }

  Future changeAsistenciaAlumno(
      int periodoID, int asistenciaID, int valor) async {
    var url = Uri.http('$domain:$port',
        '/Asistencia/Asistencia/$periodoID/cambiar/$asistenciaID');
    var data = {"Registro": valor};
    var body = json.encode(data);
    final response = await http.patch(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      return response.body;
    }
    return response.body;
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.title);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
