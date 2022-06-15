import 'package:flutter/material.dart';

class MyCustomersScreen extends StatefulWidget {
  const MyCustomersScreen({Key? key}) : super(key: key);

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
