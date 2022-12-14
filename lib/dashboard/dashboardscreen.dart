import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kecs/bill/billscreen.dart';
import 'package:kecs/floating_modal.dart';
import 'package:kecs/login.dart';
import 'package:kecs/modal_fit.dart';
import 'package:kecs/profile/profilescreen.dart';
import 'package:kecs/report/report.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:app_settings/app_settings.dart';

class DashboardScreen extends StatefulWidget {
  final dynamic fullname;
  final dynamic jobtitle;
  final dynamic payrollid;
  final dynamic areaoffice;
  final dynamic id;
  final dynamic feeder;
  final dynamic phonenumber;
  final dynamic emaill;

  const DashboardScreen(
      {Key? key,
      this.fullname,
      this.jobtitle,
      this.payrollid,
      this.areaoffice,
      this.id,
      this.feeder,
      this.phonenumber,
      this.emaill})
      : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final key = GlobalKey<FormState>();

  late String _timestring;
  String delivered = '';
  String notDelivered = '';
  String total = '';

  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;

  @override
  void initState() {
    checkGps();
    _timestring =
        "${DateFormat('EEEE').format(DateTime.now())}, ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
    super.initState();
  }

  checkGps() async {
    // counter();

    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (!servicestatus) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return locPop('Switch on Location Service');
    } else {
      if (servicestatus) {
        permission = await Geolocator.checkPermission();

        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            //debugPrint('Location permissions are denied');
          } else if (permission == LocationPermission.deniedForever) {
            //debugPrint("'Location permissions are permanently denied");
          } else {
            haspermission = true;
          }
        } else {
          haspermission = true;
        }

        if (haspermission) {
          setState(() {
            //refresh the UI
          });
        }
      } else {
        //debugPrint("GPS Service is not enabled, turn on GPS location");
      }
    }
    setState(() {
      //refresh the UI
    });
  }

  Future counter() async {
    Uri url =
        Uri.parse('https://meterreading.kadunaelectric.com/kecs/counter.php');

    var data = {
      'ID': widget.id,
    };

    var response = await http.post(
      url,
      body: json.encode(data),
    );
    var jsondata = json.decode(response.body);

    if (response.statusCode == 200) {
      int deliveredJson = jsondata["Delivered"];
      int notDeliveredJson = jsondata["NotDelivered"];
      int totalJson = jsondata["Total"];

      setState(() {
        delivered = deliveredJson.toString();
        notDelivered = notDeliveredJson.toString();
        total = totalJson.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Do you want to exit the app?'),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('No'),
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
      child: Scaffold(
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
              children: <Widget>[
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
                  leading: const Icon(
                    Icons.home_outlined,
                    size: 25.0,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Home',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  textColor: Colors.white,
                  dense: true,
                ),
                _padding(10.0),
                listTile(
                    'Profile',
                    Icons.account_circle_outlined,
                    ProfileScreen(
                        fullname: widget.fullname,
                        id: widget.id,
                        phonenumber: widget.phonenumber,
                        emaill: widget.emaill,
                        payrollid: widget.payrollid)),
                _padding(10.0),
                listTile(
                    'Generate Report',
                    Icons.feedback_outlined,
                    ReportScreen(
                      id: widget.id,
                    )),
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
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: <Widget>[
                  texts("${widget.fullname} ${widget.payrollid}"),
                  texts(widget.feeder),
                  texts(widget.areaoffice),
                ]),
              )
            ],
          ),
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: <Widget>[
              _card('Total\nBills Processed', '\n$total'),
              _card('Bills\nDelivered', '\n$delivered'),
              _card('Bills\nUndelivered', '\n$notDelivered'),
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
            card2(Icons.receipt_long, 'Bill \n Distribution'),
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
  ) {
    return SizedBox(
      height: 120,
      width: 120,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BillScreen(
                      id: widget.id,
                    )),
          ).then(
            (_) => counter(),
          );
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
              context: context, builder: (context) => ModalFit(id: widget.id));
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

  Future<dynamic> locPop(String msg) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(msg),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                AppSettings.openLocationSettings();
              },
            ),
          ],
        );
      },
    );
  }
}
