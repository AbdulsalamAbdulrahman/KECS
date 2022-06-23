import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kecs/profile/profilescreen.dart';
import 'package:kecs/report/report.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final key = GlobalKey<FormState>();

  late String _timestring;

  @override
  void initState() {
    _timestring =
        "${DateFormat('EEEE').format(DateTime.now())}, ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
    super.initState();
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
          // padding: const EdgeInsets.symmetric(vertical: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const UserAccountsDrawerHeader(
                // <-- SEE HERE
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('green.png'), fit: BoxFit.cover),
                    color: Colors.white),
                accountName: Text(
                  "Abdulsalalm Abdulrahman",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  "09048554096",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                currentAccountPicture: Image(
                  image: AssetImage('S.png'),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10.0)),
              ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                },
                leading: const Icon(Icons.home_outlined,
                    size: 20.0, color: Colors.white),
                title: const Text(
                  'Home',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                textColor: Colors.white,
                dense: true,
              ),
              listTile(
                  'Profile', Icons.account_circle_outlined, const Profile()),
              listTile('Report', Icons.feedback_outlined, const Report()),
              ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                },
                leading: const Icon(Icons.power_settings_new_outlined,
                    size: 20.0, color: Colors.white),
                title: const Text(
                  'Sign Out',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                textColor: Colors.white,
                dense: true,
              )
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
              _card('Total\nBills Allocated', '\n1000'),
              _card('Bills\nDelivered', '\n1000'),
              _card('Bills\nUndelivered', '\n1150'),
            ],
          ),
          // Wrap(
          //   alignment: WrapAlignment.spaceEvenly,
          //   children: [
          //     _card1('Customers', '\n1000'),
          //     _card1(
          //       'Delivered',
          //       '\n100',
          //     ),
          //     _card1(
          //       'Undelivered',
          //       '\n100',
          //     ),
          //     // _card1(
          //     //   'Disc',
          //     //   '\n100',
          //     // ),
          //   ],
          // ),
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
            card2(Icons.electrical_services, 'Meter Reading', '/Meter'),
            card2(Icons.receipt_long, 'Bill \n Distribution', '/Bill'),
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            card2(Icons.bolt, 'Tracking', '/Tracking'),
            card2(Icons.people_rounded, 'My\nCustomers', '/MyCustomers')
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

  // Widget _card1(String text, String text1) {
  //   return SizedBox(
  //     height: 60,
  //     width: 87,
  //     child: Card(
  //       child: Column(children: <Widget>[
  //         Text(
  //           text,
  //           textAlign: TextAlign.center,
  //           style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
  //         ),
  //         Text(
  //           text1,
  //           style: const TextStyle(
  //             color: Colors.green,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         )
  //       ]),
  //       shape:
  //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
  //     ),
  //   );
  // }

  Widget card2(
    icon,
    String text,
    String text2,
  ) {
    return SizedBox(
      height: 120,
      width: 120,
      child: GestureDetector(
        onTap: () {
          // Navigator.of(context).pop();
          Navigator.of(context).pushNamed(text2);
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
        Navigator.of(context).pop();
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
