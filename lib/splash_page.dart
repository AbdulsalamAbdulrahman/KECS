import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
// import 'package:kecs/dashboard/dashboardscreen.dart';
import 'package:kecs/login.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // Future<Widget> futureCall() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var user = prefs.getString('user');
  //   return user == null ? const Login() : const DashboardScreen();
  // }

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      // futureNavigator: futureCall(),
      logo: Image.asset(
        'logo-kecs.png',
        height: 500,
        alignment: Alignment.center,
      ),
      logoSize: 100,
      backgroundColor: Colors.white,
      showLoader: true,
      loaderColor: Colors.green,
      loadingText: const Text(
        "Loading...",
        style: TextStyle(
          color: Color.fromARGB(255, 97, 202, 102),
        ),
      ),
      durationInSeconds: 3,
      navigator: const Login(),
    );
  }
}
