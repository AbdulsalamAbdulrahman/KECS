import 'package:flutter/material.dart';
import 'package:kecs/tracking/trackingscreen.dart';

class Tracking extends StatelessWidget {
  const Tracking({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TrackingScreen(),
    );
  }
}
