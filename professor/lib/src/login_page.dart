import 'package:flutter/material.dart';
import 'package:professor/src/service/service_api.dart';
import 'package:professor/src/tabla_asistencias.dart';

import 'activadades_crud_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _cliente = ApiService();

  final userTextField = TextEditingController();
  final contraTextField = TextEditingController();
  void bar(BuildContext context) async {
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 60.0),
              child: Center(
                child: SizedBox(

                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image(
                  image: AssetImage('assets/images/Icono.png'),
                  height: 150,
                  width: 200,
                )),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: userTextField,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User',
                    hintText: 'Usuario'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: contraTextField,
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Contrasena',
                    hintText: 'Ingrese su contrasena'),
              ),
            ),
            TextButton(
              onPressed: () {
                // FORGOT PASSWORD SCREEN GOES HERE
              },
              child: const Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () async {
                  var resp = await _cliente.login(
                      userTextField.text, contraTextField.text);

                  setState(() {
                    if (resp == true) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ActividadesCrudPage()));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ActividadesCrudPage()));
                    }
                  });
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            const SizedBox(
              height: 130,
            ),
            const Text('New User? Create Account')
          ],
        ),
      ),
    );
  }
}
