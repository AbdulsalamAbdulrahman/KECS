import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kecs/dashboard/dashboard.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final key = GlobalKey<FormState>();
  String username = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Form(
        key: key,
        child: Padding(
          padding: const EdgeInsets.all(19.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Center(
                      child: SizedBox(
                          width: 200,
                          height: 70,
                          child: Image.asset('kecs.png')))),
              user(),
              const SizedBox(height: 10.0),
              pass(),
              const SizedBox(height: 10.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(500, 50),
                  maximumSize: const Size(500, 50),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Sign in',
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  if (key.currentState!.validate()) {
                    key.currentState!.save();

                    userLogin();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget user() {
    BorderRadius.circular(30.0);

    return Material(
      child: TextFormField(
        keyboardType: TextInputType.text,
        onSaved: (value) => username = value.toString(),
        onChanged: (value) {
          if (value.isNotEmpty) {}
          // return null;
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "please enter your username";
          }
          return null;
        },
        decoration: decorate("Username", Icons.person, 'Phone Number'),
      ),
    );
  }

  Widget pass() {
    return Material(
      child: TextFormField(
        keyboardType: TextInputType.text,
        obscureText: true,
        onSaved: (value) => password = value.toString(),
        onChanged: (value) {
          if (value.isNotEmpty) {}
          // return null;
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "please enter your password";
          }
          return null;
        },
        decoration: decorate("Password", Icons.lock, 'Password'),
      ),
    );
  }

  Future userLogin() async {
    Uri url =
        Uri.parse('https://kadunaelectric.com/meterreading/mobile_login.php');

    var data = {'username': username, 'password': password};
    debugPrint(username);
    debugPrint(password);

    var response = await http.post(url, body: json.encode(data));

    var message = jsonDecode(response.body);
    debugPrint(message);

    if (message == 'Login Successful') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Dashboard()));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(message, style: const TextStyle(color: Colors.red)),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  InputDecoration decorate(String label, icon, String hint) {
    return InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(),
        ));
  }
}
