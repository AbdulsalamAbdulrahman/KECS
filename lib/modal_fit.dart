import 'package:flutter/material.dart';
import 'package:kecs/tracking/nonppm_tracking.dart';
import 'package:kecs/tracking/trackingscreen.dart';

class ModalFit extends StatelessWidget {
  final String id;
  const ModalFit({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: const Text('PPM'),
            leading: const Icon(Icons.bolt),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TrackingScreen(
                          id: id,
                        ))),
          ),
          ListTile(
            title: const Text('NON-PPM'),
            leading: const Icon(Icons.bolt),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NonPPMScreen(
                          id: id,
                        ))),
          )
        ],
      ),
    ));
  }
}
