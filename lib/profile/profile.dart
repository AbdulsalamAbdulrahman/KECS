import 'package:back_pressed/back_pressed.dart';
import 'package:flutter/material.dart';
import 'package:kecs/profile/profilescreen.dart';

import '../dashboard/dashboardscreen.dart';

class Profile extends StatelessWidget {
  static String routeName = "/Profile";

  const Profile({Key? key, required String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: OnBackPressed(
      perform: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const DashboardScreen(
                      title: '',
                    )));
        // debugPrint('The back button on the device was pressed');
      },
      child: const Scaffold(
        body: ProfileScreen(title: ''),
      ),
    ));
  }
}
