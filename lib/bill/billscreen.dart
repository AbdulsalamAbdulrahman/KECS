import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kecs/bill/delivered.dart';
import 'package:kecs/bill/notdelivered.dart';
import 'package:geolocator/geolocator.dart';

class BillScreen extends StatefulWidget {
  final String id;

  const BillScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  final key = GlobalKey<FormState>();

  bool _isLoading = false;

  String accno = "";
  String name = '';
  String address = "";
  String accnumber = '';
  String meterno = "";
  String lastpay = "";
  double closingb = 0;
  double lastpayamt = 0;
  String geolat = '';
  String geolong = '';

  String dropdownValue = 'Select Status';

  // geo
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;

  @override
  void initState() {
    checkGps();
    super.initState();
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
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

    setState(() {
      //refresh the UI
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        forceAndroidLocationManager: true,
        desiredAccuracy: LocationAccuracy.high);
    // print(position.longitude); //Output: 80.24599079
    // print(position.latitude); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();

    // //debugPrint("$long, $lat");

    setState(() {
      geolong = long;
      geolat = lat;
    });
  }

  Future getAccNo() async {
    setState(() {
      _isLoading = true;
    });

    Uri url = Uri.parse(
        'https://meterreading.kadunaelectric.com/kecs/dotnet_billinghistory.php?id=$accno');

    // try {
    var data = {
      'accno': accno,
    };

    var response = await http.post(
      url,
      body: json.encode(data),
    );

    final jsondata = json.decode(response.body);

    if (jsondata == "Invalid Account Number") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                Text(jsondata, style: const TextStyle(color: Colors.black54)),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      String namejson = jsondata[0]['customerName'] ?? "Unavailable";
      String addressjson = jsondata[0]['customerAddress'] ?? "Unavailable";
      String accnumberjson = jsondata[0]['customerAccountNo'] ?? "Unavailable";
      String meternojson = jsondata[0]['meterNumber'] ?? "Unavailable";
      String lastpayjson = jsondata[0]['lastPaymentDate'] ?? "Unavailable";
      double closingbjson = jsondata[0]['closingBalance'] ?? "Unavailable";
      double lastpayamtjson = jsondata[0]['lastPaymentAmount'] ?? "Unavailable";

      setState(() {
        accnumber = accnumberjson;
        name = namejson;
        address = addressjson;
        meterno = meternojson;
        lastpay = lastpayjson;
        closingb = closingbjson;
        lastpayamt = lastpayamtjson;
      });
    }
    // } catch (e) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    //   return showMessage('Invalid Account Number');
    // }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Distribution'),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Material(
              child: Column(
            children: <Widget>[
              Form(
                  child: Column(
                children: <Widget>[
                  card(),
                  card1(),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(500, 50),
                          maximumSize: const Size(500, 50),
                        ),
                        onPressed: name ==
                                "" //fix logic not working on app even if geo is not  disable counter to test app update
                            ? null
                            : () {
                                if (dropdownValue == 'Delivered' &&
                                    geolat != '') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DeliveredScreen(
                                                accnumber: accnumber,
                                                name: name,
                                                address: address,
                                                meterno: meterno,
                                                lastpay: lastpay,
                                                closingb: closingb,
                                                lastpayamt: lastpayamt,
                                                dropdownValue: dropdownValue,
                                                geolat: geolat,
                                                geolong: geolong,
                                                id: widget.id,
                                              )));
                                } else if (dropdownValue == 'Not Delivered' &&
                                    geolat != '') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NotDeliveredScreen(
                                                accnumber: accnumber,
                                                name: name,
                                                address: address,
                                                meterno: meterno,
                                                lastpay: lastpay,
                                                closingb: closingb,
                                                lastpayamt: lastpayamt,
                                                dropdownValue: dropdownValue,
                                                geolat: geolat,
                                                geolong: geolong,
                                                id: widget.id,
                                              )));
                                } else if (geolat == '' && geolong == '') {
                                  showMessageG(
                                      'Your Geo Location is needed. Click on OK to get Geo Location');
                                }
                              },
                        child: const Text('Continue')),
                  ),
                ],
              ))
            ],
          ))
        ],
      ),
    );
  }

  Widget card() {
    return SizedBox(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Search Customer',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const Padding(padding: EdgeInsets.all(5.0)),
                Form(
                  key: key,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    onSaved: (value) => accno = value.toString(),
                    onChanged: (value) {
                      if (value.isNotEmpty) {}
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please enter your account number";
                      }
                      return null;
                    },
                    // controller: _inputController,

                    decoration: decorate('Account Number'),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(3.0)),
                ElevatedButton.icon(
                  icon: _isLoading
                      ? const SizedBox(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                          height: 15.0,
                          width: 15.0,
                        )
                      : const Text(''),
                  label: Text(
                    _isLoading ? '' : 'Search Account',
                    style: const TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    if (key.currentState!.validate()) {
                      key.currentState!.save();
                      FocusScope.of(context).unfocus();
                      _isLoading ? null : getAccNo();
                      getLocation();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(500, 50),
                    maximumSize: const Size(500, 50),
                  ),
                )
              ]),
        ),
        elevation: 5,
        shadowColor: Colors.green,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
              color: Colors.green, style: BorderStyle.solid, width: 2.0),
        ),
      ),
    );
  }

  Widget card1() {
    return SizedBox(
      width: 500,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Customer Billing Information',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                Wrap(
                    textDirection: TextDirection.ltr,
                    verticalDirection: VerticalDirection.down,
                    direction: Axis.vertical,
                    alignment: WrapAlignment.start,
                    children: <Widget>[
                      container('Name: ', name),
                      container('Address: ', address),
                      container('Account Number:', accnumber),
                      container('Meter Number:', meterno),
                      container('Last Payment Date:', lastpay),
                      container2('Last Payment Amount:', lastpayamt),
                      container2('Closing Balance:', closingb),
                      dropDown(),
                    ]),
                const Padding(padding: EdgeInsets.all(5.0)),
                const Padding(padding: EdgeInsets.all(5.0)),
              ]),
        ),
        elevation: 5,
        shadowColor: Colors.green,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
              color: Colors.green, style: BorderStyle.solid, width: 2.0),
        ),
      ),
    );
  }

  Widget container(text, text1) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      child: Row(
        children: <Widget>[
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            text1,
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Widget container2(text, double text1) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      child: Row(
        children: <Widget>[
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '$text1',
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Widget container3(text, int text1) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      child: Row(
        children: <Widget>[
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            text1.toString(),
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Widget dropDown() {
    return DropdownButton<String>(
      value: dropdownValue,
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['Select Status', 'Delivered', 'Not Delivered']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        );
      }).toList(),
    );
  }

  Future<dynamic> showMessage(String msg) async {
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
              },
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> showMessageG(String msg) async {
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
                checkGps();
                getLocation();
              },
            ),
          ],
        );
      },
    );
  }

  InputDecoration decorate(String label) {
    return InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(),
        ));
  }
}
