import 'package:flutter/material.dart';
import 'package:kecs/meterreading/meter_screen.dart';

class Meter extends StatelessWidget {
  static String routeName = "/meterreading";

  const Meter({Key? key, required String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MeterScreen(title: ''),
    );
  }
}
