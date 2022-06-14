import 'package:back_pressed/back_pressed.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:kecs/bill/bill.dart';
import 'package:kecs/meterreading/meter_screen.dart';
import 'package:kecs/mycustomers/mycustomers.dart';
import 'package:kecs/profile/profilescreen.dart';
import 'package:kecs/report/report.dart';
import 'package:kecs/tracking/tracking.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final key = GlobalKey<FormState>();

  late String _timestring;

  @override
  void initState() {
    _timestring =
        "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getCurrentTime());
    super.initState();
  }

  void _getCurrentTime() {
    setState(() {
      _timestring =
          "${DateFormat('EEEE').format(DateTime.now())}, ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
    });
  }

  void doubleBack() {
    const DoubleBackToCloseApp(
      child: DashboardScreen(
        title: '',
      ),
      snackBar: SnackBar(
        content: Text('Tap back again to leave'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      drawer: Drawer(
        backgroundColor: Colors.green,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    // SizedBox(
                    //   child: Image.asset('kecs.png'),
                    // ),
                    Padding(padding: EdgeInsets.only(top: 50.0)),
                    CircleAvatar(
                      child: Icon(
                        Icons.person,
                        color: Colors.green,
                      ),
                      backgroundColor: Colors.white,
                      radius: 22.0,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      "Hello, Abdulsalam Abdulrahman",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
              const Divider(
                height: 1,
                thickness: 1,
              ),
              listTile('Home', Icons.home, const DashboardScreen(title: '')),
              listTile('Profile', Icons.account_circle,
                  const ProfileScreen(title: '')),
              listTile('Report', Icons.feedback, const ReportScreen(title: '')),
              listTile('Logout', Icons.power_settings_new,
                  const DashboardScreen(title: '')),
            ],
          ),
        ),
      ),
      body: DoubleBackToCloseApp(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            up(),
            down(),
          ],
        ),
        snackBar: const SnackBar(
          content: Text('Tap back again to leave'),
        ),
      ),
    );
  }

  Widget up() {
    return Card(
      color: Colors.green,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            _timestring,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              decoration: TextDecoration.none,
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: [
                  texts("Abdulsalam Abdulrahman(109083)"),
                  texts("33kv Kawo"),
                  texts("KAWO AREA OFFICE"),
                ]),
              )
            ],
          ),
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: [
              _card('Total\nTarget', '\n1000'),
              _card('Collection\nResponse', '\n1000'),
              _card('Total\nCollection', '\n1150'),
            ],
          ),
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: [
              _card1('Customers', '\n1000'),
              _card1(
                'Delivered',
                '\n100',
              ),
              _card1(
                'Undelivered',
                '\n100',
              ),
              _card1(
                'Defaulters',
                '\n100',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget down() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Padding(padding: EdgeInsets.only(top: 25.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            card2(Icons.electrical_services, 'Meter Reading',
                const MeterScreen(title: '')),
            card2(Icons.receipt_long, 'Bill \n Distribution',
                const Bill(title: '')),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            card2(Icons.bolt, 'Tracking', const Tracking(title: '')),
            card2(Icons.people_rounded, 'My\nCustomers',
                const MyCustomers(title: ''))
          ],
        ),
      ],
    );
  }

  Widget texts(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        decoration: TextDecoration.none,
      ),
    );
  }

  Widget _card(String text, String text1) {
    return SizedBox(
      height: 80,
      width: 110,
      child: Card(
        child: Column(children: <Widget>[
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              decoration: TextDecoration.none,
            ),
          ),
          Text(
            text1,
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          )
        ]),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      ),
    );
  }

  Widget _card1(String text, String text1) {
    return SizedBox(
      height: 60,
      width: 87,
      child: Card(
        child: Column(children: <Widget>[
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          Text(
            text1,
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          )
        ]),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      ),
    );
  }

  Widget card2(
    icon,
    String text,
    log,
  ) {
    return SizedBox(
      height: 120,
      width: 120,
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return log;
          }));
        },
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                color: Colors.green,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.green),
              ),
            ],
          ),
          elevation: 5,
          shadowColor: Colors.green,
          shape: RoundedRectangleBorder(
              side: const BorderSide(
                  color: Colors.green, style: BorderStyle.solid, width: 2.0),
              borderRadius: BorderRadius.circular(15.0)),
        ),
      ),
    );
  }

  Widget listTile(String text, icon, log) {
    return ListTile(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return log;
        }));
      },
      leading: Icon(icon, size: 20.0, color: Colors.white),
      title: Text(
        text,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      textColor: Colors.white,
      dense: true,

      // padding: EdgeInsets.zero,
    );
  }
}
