import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:kecs/dashboard/dashboardscreen.dart';

class Dashboard extends StatelessWidget {
  static String routeName = "/dashboard";

  const Dashboard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DoubleBackToCloseApp(
        child: DashboardScreen(
          title: '',
        ),
        snackBar: SnackBar(
          content: Text('Tap back again to leave'),
        ),
      ),
    );
  }
}
