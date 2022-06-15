import 'package:flutter/material.dart';
import 'package:kecs/mycustomers/mycustomerscreen.dart';

class MyCustomers extends StatelessWidget {
  const MyCustomers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MyCustomersScreen(),
    );
  }
}
