import 'package:flutter/material.dart';
import 'package:kecs/connection/connection.dart';
import 'package:kecs/profile/profilescreen.dart';
import 'package:kecs/report/report.dart';
import 'package:intl/intl.dart';
import '../login.dart';

class DashboardScreen2 extends StatefulWidget {
  final String fullname;
  final String jobtitle;
  final String payrollid;
  final String areaoffice;
  final String id;
  final String feeder;
  final String phonenumber;
  final dynamic emaill;

  const DashboardScreen2({
    Key? key,
    required this.fullname,
    required this.jobtitle,
    required this.payrollid,
    required this.areaoffice,
    required this.id,
    required this.feeder,
    required this.phonenumber,
    this.emaill,
  }) : super(key: key);

  @override
  State<DashboardScreen2> createState() => _DashboardScreen2State();
}

class _DashboardScreen2State extends State<DashboardScreen2> {
  final key = GlobalKey<FormState>();

  late String _timestring;
  String id = '';

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
              UserAccountsDrawerHeader(
                // <-- SEE HERE
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('S.jpg'), fit: BoxFit.cover),
                    color: Colors.white),
                accountName: Text(
                  "${widget.fullname}\n${widget.emaill}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  widget.jobtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                currentAccountPicture: const Image(
                  image: AssetImage('KK.png'),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10.0)),
              ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                },
                leading: const Icon(Icons.home_outlined,
                    size: 25.0, color: Colors.white),
                title: const Text(
                  'Home',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                textColor: Colors.white,
                dense: true,
              ),
              const Padding(padding: EdgeInsets.only(top: 10.0)),
              listTile(
                  'Profile',
                  Icons.account_circle_outlined,
                  ProfileScreen(
                      fullname: widget.fullname,
                      id: widget.id,
                      phonenumber: widget.phonenumber,
                      emaill: widget.emaill,
                      payrollid: widget.payrollid)),
              const Padding(padding: EdgeInsets.only(top: 10.0)),
              listTile(
                  'Generate Report', Icons.feedback_outlined, const Report()),
              const Padding(padding: EdgeInsets.only(top: 10.0)),
              // listTile('My Customers', Icons.people_outline_rounded,
              //     const MyCustomers()),
              // const Padding(padding: EdgeInsets.only(top: 10.0)),
              ListTile(
                onTap: () async {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const Login()),
                      (route) => false);
                },
                leading: const Icon(Icons.power_settings_new_outlined,
                    size: 25.0, color: Colors.white),
                title: const Text(
                  'Sign Out',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                textColor: Colors.white,
                dense: true,
              )
            ],
          ),
        ),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          up(),
          down(),
        ],
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
                  texts("${widget.fullname} ${widget.payrollid}"),
                  texts(widget.feeder),
                  texts(widget.areaoffice),
                ]),
              )
            ],
          ),
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: [
              _card('Diconnected', '\n0'),
              _card('Reconnected', '\n0'),
              _card('Defaulters', '\n0'),
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
            card3(Icons.electrical_services, 'Meter Reading', '/Meter'),
            card3(Icons.receipt_long, 'Bill \n Distribution', '/Bill'),
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            card3(Icons.bolt, 'Tracking', '/Tracking'),
            card2(Icons.bolt, 'Disconnection\nReconnection', '/Connection')
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
          // Navigator.of(context).pushNamed(text2);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ConnectionScreen(
                        id: id,
                      )));
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

  Widget card3(
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
          // Navigator.of(context).pushNamed(text2);
        },
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                color: Colors.grey,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          elevation: 5,
          shadowColor: Colors.green,
          shape: RoundedRectangleBorder(
              side: const BorderSide(
                  color: Colors.grey, style: BorderStyle.solid, width: 2.0),
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
      leading: Icon(icon, size: 25.0, color: Colors.white),
      title: Text(
        text,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      textColor: Colors.white,
      dense: true,

      // padding: EdgeInsets.zero,
    );
  }
}
