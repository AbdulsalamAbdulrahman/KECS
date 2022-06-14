import 'package:back_pressed/back_pressed.dart';
import 'package:flutter/material.dart';
import '../dashboard/dashboard.dart';
// import '../dashboard/dashboardscreen.dart';

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
        child: OnBackPressed(
            child: Column(
              children: <Widget>[
                AppBar(
                  leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context, true);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Dashboard()));
                      }),
                  title: const Text('Report'),
                )
              ],
            ),
            perform: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Dashboard()));
            }));
  }

  // Widget back() {
  //   return BackButtonListener(child: child, onBackButtonPressed: onBackButtonPressed)
  // }
}
