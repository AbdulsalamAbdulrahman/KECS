import 'package:flutter/material.dart';
import 'package:kecs/mycustomers/mycustomerscreen.dart';

class MyCustomers extends StatelessWidget {
  static String routeName = "/MyCustomers";

  const MyCustomers({Key? key, required String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MyCustomersScreen(title: ''),
    );
  }
}
