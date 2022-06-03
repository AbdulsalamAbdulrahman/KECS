import 'package:flutter/material.dart';

class MyCustomersScreen extends StatefulWidget {
  const MyCustomersScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyCustomersScreen> createState() => _MyCustomersScreenState();
}

class _MyCustomersScreenState extends State<MyCustomersScreen> {
  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            AppBar(
              title: const Text('My Customers'),
            )
          ],
        ));
  }
}
