import 'package:flutter/material.dart';

class Report extends StatelessWidget {
  static String routeName = "/Report";

  const Report({Key? key, required String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
      ),
      body: const ReportScreen(title: ''),
    );
  }
}

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final key = GlobalKey<FormState>();
  String dropdownValue = 'Select Reason';
  bool valuefirst = false;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            AppBar(
              title: const Text('Report'),
            )
          ],
        ));
  }
}
