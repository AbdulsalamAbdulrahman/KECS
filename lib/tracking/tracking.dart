import 'package:flutter/material.dart';
import 'package:kecs/tracking/trackingscreen.dart';

class Tracking extends StatelessWidget {
  static String routeName = "/Tracking";

  const Tracking({Key? key, required String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TrackingScreen(title: ''),
    );
  }
}
