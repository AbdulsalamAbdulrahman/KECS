import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:kecs/dashboard/dashboardscreen.dart';
// import 'package:kecs/bill/billscreen.dart';
import 'package:kecs/tracking/tracking.dart';
// import 'login.dart';

void main() {
  // add these lines
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KECS',
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      // home: const Login(title: 'Commercial Solution'),
      home: const Tracking(title: 'Commercial Solution'),
      // home: const DashboardScreen(title: 'Commercial Solution'),
      // home: const BillScreen(title: 'Commercial Solution'),
    );
  }
}
