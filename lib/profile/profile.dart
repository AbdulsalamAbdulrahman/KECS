import 'package:flutter/material.dart';
import 'package:kecs/profile/profilescreen.dart';

class Profile extends StatelessWidget {
  static String routeName = "/Profile";

  const Profile({Key? key, required String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ProfileScreen(title: ''),
    );
  }
}
