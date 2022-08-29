import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
// import 'package:kecs/dashboard/dashboard.dart';
// import 'package:kecs/dashboard/dashboardscreen.dart';
import 'package:kecs/login.dart';
// import 'package:kecs/bill/bill.dart';
// import 'package:kecs/login.dart';
// import 'package:kecs/tracking/trackingscreen.dart';

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
      backgroundColor: Colors.white,
      showLoader: true,
      loaderColor: Colors.green,
      loadingText: const Text(
        "Loading...",
        style: TextStyle(
          color: Color.fromARGB(255, 73, 95, 74),
        ),
      ),
      navigator: const Login(),
      durationInSeconds: 3,
    );
  }
}
