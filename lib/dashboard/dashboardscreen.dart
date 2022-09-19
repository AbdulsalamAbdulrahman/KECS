import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kecs/floating_modal.dart';
import 'package:kecs/login.dart';
import 'package:kecs/modal_fit.dart';
import 'package:kecs/profile/profilescreen.dart';
import 'package:kecs/report/report.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String fullname = '';
  String jobtitle = "";
  String payrollid = "";
  String areaoffice = "";
  String feeder = "";

  final key = GlobalKey<FormState>();

  late String _timestring;

  @override
  void initState() {
    _timestring =
        "${DateFormat('EEEE').format(DateTime.now())}, ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
    super.initState();
    _getCred();
  }

  void _getCred() async {
    SharedPreferences prefLogin = await SharedPreferences.getInstance();
    setState(() {
      fullname = prefLogin.getString("fullname")!;
      jobtitle = prefLogin.getString("jobtitle")!;
      payrollid = prefLogin.getString("payrollid")!;
      areaoffice = prefLogin.getString("areaoffice")!;
      feeder = prefLogin.getString("feeder")!;
    });
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
                  fullname,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  jobtitle,
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
              _padding(10.0),
              listTile(
                  'Profile', Icons.account_circle_outlined, const Profile()),
              _padding(10.0),
              listTile(
                  'Generate Report', Icons.feedback_outlined, const Report()),
              const Padding(padding: EdgeInsets.only(top: 10.0)),
              // listTile('My Customers', Icons.people_outline_rounded,
              //     const MyCustomers()),
              // const Padding(padding: EdgeInsets.only(top: 10.0)),
              ListTile(
                onTap: () async {
                  SharedPreferences prefLogin =
                      await SharedPreferences.getInstance();
                  await prefLogin.clear();
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
                  texts("$fullname $payrollid"),
                  texts(feeder),
                  texts(areaoffice),
                ]),
              )
            ],
          ),
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: [
              _card('Total\nBills Processed', '\n0'),
              _card('Bills\nDelivered', '\n0'),
              _card('Bills\nUndelivered', '\n0'),
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
            card2(Icons.receipt_long, 'Bill \n Distribution', '/Bill'),
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _card2(Icons.bolt, 'Tracking'),
            card3(Icons.bolt, 'Disconnection\nReconnection', '/Connection')
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

  Widget _card2(icon, String text) {
    return SizedBox(
      height: 120,
      width: 120,
      child: GestureDetector(
        onTap: () {
          // Navigator.of(context).pop();
          // Navigator.of(context).pushNamed(text2);
          showFloatingModalBottomSheet(
              context: context, builder: (context) => const ModalFit());
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

  Padding _padding(value) {
    return Padding(padding: EdgeInsets.all(value));
  }
}
