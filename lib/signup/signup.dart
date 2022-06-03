import 'package:flutter/material.dart';
//import 'package:kecs/login.dart';
import 'package:kecs/signup/signupscreen.dart';

//import 'view.dart';

class Signup extends StatelessWidget {
  static String routeName = "/signup";

  const Signup({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Signupscreen(title: 'Commercial Solution'),
    );
  }
}
