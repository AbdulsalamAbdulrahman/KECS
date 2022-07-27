import 'package:flutter/material.dart';
import 'package:kecs/bill/billscreen.dart';

class Bill extends StatelessWidget {
  const Bill({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BillScreen(),
      // appBar: AppBar(),
    );
  }
}
