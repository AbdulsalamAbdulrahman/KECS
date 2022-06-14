import 'package:flutter/material.dart';
import 'package:kecs/dashboard/dashboardscreen.dart';

class Dashboard extends StatelessWidget {
  static String routeName = "/dashboard";

  const Dashboard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DashboardScreen(title: ''),
    );
  }
}
