import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kecs/bill/billscreen.dart';
import 'package:kecs/connection/connection.dart';
import 'package:kecs/meter/meterreading.dart';
import 'package:kecs/modal_fit.dart';
import 'package:kecs/mycustomers/mycustomers.dart';
import 'package:kecs/splash_page.dart';
import 'package:kecs/tracking/nonppm_tracking.dart';
import 'package:kecs/tracking/tracking.dart';

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
      home: const SplashPage(),
      routes: <String, WidgetBuilder>{
        '/Bill': (BuildContext context) => const BillScreen(),
        '/MyCustomers': (BuildContext context) => const MyCustomers(),
        '/Tracking': (BuildContext context) => const Tracking(),
        '/NonPPM': (BuildContext context) => const NonPPM(),
        '/Connection': (BuildContext context) => const Connection(),
        '/Meter': (BuildContext context) => const Meter(),
        '/ModalFit': (BuildContext context) => const ModalFit(),
      },
    );
  }
}
