import 'package:flutter/material.dart';
import 'package:kecs/meterreading/meter_screen.dart';

class Meter extends StatelessWidget {
  const Meter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MeterScreen(),
    );
  }
}
