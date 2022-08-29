import 'package:flutter/material.dart';

class ModalFit extends StatelessWidget {
  const ModalFit({Key? key}) : super(key: key);

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
            onTap: () => Navigator.of(context).pushNamed('/Tracking'),
          ),
          ListTile(
            title: const Text('NON-PPM'),
            leading: const Icon(Icons.bolt),
            onTap: () => Navigator.of(context).pushNamed('/NonPPM'),
          )
        ],
      ),
    ));
  }
}
