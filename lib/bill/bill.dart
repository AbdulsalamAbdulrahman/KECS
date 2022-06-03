import 'package:flutter/material.dart';
import 'package:kecs/bill/billscreen.dart';

class Bill extends StatelessWidget {
  static String routeName = "/bill";

  const Bill({Key? key, required String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BillScreen(title: ''),
    );
  }
}
