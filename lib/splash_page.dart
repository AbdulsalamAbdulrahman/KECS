import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:kecs/dashboard/dashboardscreen.dart';
// import 'package:kecs/dashboard/dashboardscreen.dart';
// import 'login.dart';1
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset(
        'kecs.png',
        alignment: Alignment.center,
      ),
      logoSize: 100,
      title: const Text(
        "",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
      backgroundColor: Colors.white,
      showLoader: true,
      loaderColor: Colors.green,
      loadingText: const Text(
        "Loading...",
        style: TextStyle(
          color: Colors.green,
        ),
      ),
      navigator: const DashboardScreen(title: ''),
      durationInSeconds: 2,
    );
  }
}
