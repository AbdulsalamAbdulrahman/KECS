//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kecs/login.dart';
// import 'package:http/http.dart' as http;
// import 'package:kecs/dashboard.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({Key? key, required this.title}) : super(key: key);
  //String  username;
  final String title;

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  final key = GlobalKey<FormState>();
  String fname = '';
  String department = '';
  String urole = '';
  String proll = '';
  String jt = '';
  String username = '';
  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      // margin: const EdgeInsets.all(30.0),
      child: Padding(
        padding: const EdgeInsets.all(19.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            name(),
            const SizedBox(height: 10.0),
            dept(),
            const SizedBox(height: 10.0),
            role(),
            const SizedBox(height: 10.0),
            payroll(),
            const SizedBox(height: 10.0),
            jobtitle(),
            const SizedBox(height: 10.0),
            user(),
            const SizedBox(height: 10.0),
            pass(),
            const SizedBox(height: 10.0),
            const SizedBox(height: 10.0),
            const SizedBox(height: 10.0),
            const SizedBox(height: 10.0),
            const SizedBox(height: 10.0),
            ElevatedButton(
              child: Container(
                alignment: Alignment.center,
                child: const Text('Sign up', style: TextStyle(fontSize: 15.0)),
              ),
              onPressed: () {
                //Navigator.pop(context);
              },
            ),
            // TextButton(
            //     style: TextButton.styleFrom(
            //       primary: Colors.black,
            //     ),
            //     onPressed: () {},
            //     child: const Text('Dont have an account?')),
            const Text('Already have an account?'),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const Login(
                                title: '',
                              ))));
                },
                child: const Text('Login')),
          ],
        ),
      ),
    );
  }

  Widget name() {
    BorderRadius.circular(30.0);

    return Material(
      child: TextFormField(
        keyboardType: TextInputType.text,
        onSaved: (value) => fname = value.toString(),
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
        decoration: decorate("FullName"),
      ),
    );
  }

  Widget dept() {
    BorderRadius.circular(30.0);

    return Material(
      child: TextFormField(
        keyboardType: TextInputType.text,
        onSaved: (value) => department = value.toString(),
        onChanged: (value) {
          if (value.isNotEmpty) {}
          // return null;
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "please select department";
          }
          return null;
        },
        decoration: decorate("Department"),
      ),
    );
  }

  Widget role() {
    BorderRadius.circular(30.0);

    return Material(
      child: TextFormField(
        keyboardType: TextInputType.text,
        onSaved: (value) => urole = value.toString(),
        onChanged: (value) {
          if (value.isNotEmpty) {}
          // return null;
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "please select Role";
          }
          return null;
        },
        decoration: decorate("Role"),
      ),
    );
  }

  Widget payroll() {
    BorderRadius.circular(30.0);

    return Material(
      child: TextFormField(
        keyboardType: TextInputType.text,
        onSaved: (value) => proll = value.toString(),
        onChanged: (value) {
          if (value.isNotEmpty) {}
          // return null;
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "please enter payrollId";
          }
          return null;
        },
        decoration: decorate("PayRoll ID"),
      ),
    );
  }

  Widget jobtitle() {
    BorderRadius.circular(30.0);

    return Material(
      child: TextFormField(
        keyboardType: TextInputType.text,
        onSaved: (value) => jt = value.toString(),
        onChanged: (value) {
          if (value.isNotEmpty) {}
          // return null;
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "please select Role";
          }
          return null;
        },
        decoration: decorate("Jobtitle"),
      ),
    );
  }

  Widget user() {
    BorderRadius.circular(30.0);

    return Material(
      child: TextFormField(
        keyboardType: TextInputType.text,
        onSaved: (value) => jt = value.toString(),
        onChanged: (value) {
          if (value.isNotEmpty) {}
          // return null;
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "please enter username";
          }
          return null;
        },
        decoration: decorate("Username"),
      ),
    );
  }

  Widget pass() {
    BorderRadius.circular(30.0);

    return Material(
      child: TextFormField(
        keyboardType: TextInputType.text,
        onSaved: (value) => jt = value.toString(),
        onChanged: (value) {
          if (value.isNotEmpty) {}
          // return null;
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "please enter your Passsword";
          }
          return null;
        },
        decoration: decorate("Password"),
      ),
    );
  }

  InputDecoration decorate(String label) {
    return InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(),
        ));
  }
}
