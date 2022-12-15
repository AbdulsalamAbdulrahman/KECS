import 'package:flutter/material.dart';
import 'package:kecs/meter/status.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class MeterScreen extends StatefulWidget {
  final String id;
  const MeterScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<MeterScreen> createState() => _MeterScreenState();
}

class _MeterScreenState extends State<MeterScreen> {
  final key = GlobalKey<FormState>();
  bool _isLoading = false;

  String meterno = '';
  String meternumber = "";
  int accnum = 0;
  String name = '';
  String address = "";
  String feeder33 = "";
  String feeder11 = "";
  String regional = '';
  bool isMD = false;
  String llastdate = '';
  String llastamount = '';
  String dropdownValue = 'Select Status';
  String geolat = '';
  String geolong = '';

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

  Future getMeterInfo() async {
    setState(() {
      _isLoading = true;
    });

    Uri url = Uri.parse(
        'https://kadunaelectric.com/meterreading/kecs/search.php?uid=$meterno');

    try {
      var data = {
        'meterno': meterno,
      };

      var response = await http.post(
        url,
        body: json.encode(data),
      );

      final jsondata = json.decode(response.body);

      if (jsondata != "Invalid Meter Number") {
        final jsondata = json.decode(response.body);

        String namejson = jsondata['customerName'] ?? "Unavailable";
        String addressjson = jsondata['customerAddress'] ?? "Unavailable";
        String accno = jsondata['customerAccountNo'] ?? "Unavailable";
        String meternumberjson = jsondata['meterNumber'] ?? "No Meter";
        String feeder33json = jsondata['feeder33kV'] ?? "Unavailable";
        String feeder11json = jsondata['feeder11KV'] ?? "Unavailable";
        String regionaljson = jsondata['regionalOffice'] ?? "Unavailable";
        bool isMDjson = jsondata['isMD'] ?? "Unavailable";

        int myInt = int.parse(accno);

        setState(() {
          accnum = myInt;
          meternumber = meternumberjson;
          name = namejson;
          address = addressjson;
          feeder33 = feeder33json;
          feeder11 = feeder11json;
          regional = regionaljson;
          isMD = isMDjson;
        });
      } else {
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
      }
      getLastPayment();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // return showMessage('Invalid Meter Number');
    }
  }

  Future getLastPayment() async {
    Uri url = Uri.parse(
        'https://meterreading.kadunaelectric.com/kecs/searchpaymentresult.php?uid=$accnum');

    var response = await http.post(
      url,
      body: json.encode(accnum),
    );

    var jsondata = json.decode(response.body);

    if (jsondata != "Invalid Meter Number") {
      final jsondata = json.decode(response.body);

      String lastdate = jsondata[0]['dateCreated'];
      String lastamount = jsondata[0]['amountPaid'].toString();

      setState(() {
        llastdate = lastdate;
        llastamount = lastamount;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meter Reading')),
      body: ListView(children: <Widget>[
        Material(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Wrap(
                  children: <Widget>[
                    // const Padding(padding: EdgeInsets.all(20.0)),
                    card(),
                    card1(),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(500, 50),
                            maximumSize: const Size(500, 50),
                          ),
                          onPressed: llastamount == ""
                              ? null
                              : () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => StatusScreen(
                                                accnum: accnum,
                                                meternumber: meternumber,
                                                name: name,
                                                address: address,
                                                feeder33: feeder33,
                                                feeder11: feeder11,
                                                regional: regional,
                                                isMD: isMD,
                                                llastdate: llastdate,
                                                llastamount: llastamount,
                                                geolat: geolat,
                                                geolong: geolong,
                                                id: widget.id,
                                              )));
                                },
                          child: const Text('Continue')),
                    ),
                  ],
                )
              ],
            ))
      ]),
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
                    onSaved: (value) => meterno = value.toString(),
                    onChanged: (value) {
                      if (value.isNotEmpty) {}
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please enter your meter number";
                      }
                      return null;
                    },
                    // controller: _inputController,
                    keyboardType: TextInputType.text,
                    decoration: decorate('Meter Number'),
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
                    _isLoading ? '' : 'Search Meter Number',
                    style: const TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    if (key.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      key.currentState!.save();
                      _isLoading ? null : getMeterInfo();
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
                    container('Meter Number:', meternumber),
                    container3('Account Number:', accnum),
                    container('feeder 33KV:', feeder33),
                    container('feeder 11KV:', feeder11),
                    container('Regional Office:', regional),
                    container2('isMD:', isMD),
                    container('Last Vending Date:', llastdate),
                    container('Last Amount Vended:', llastamount),
                    // dropDown(),
                  ],
                ),
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

  Widget container(text, String text1) {
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

  Widget container2(text, bool text1) {
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
      items: <String>[
        'Select Status',
        'Ok',
        'Unpaid',
      ].map<DropdownMenuItem<String>>((String value) {
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

  InputDecoration decorate(String label) {
    return InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(),
        ));
  }
}
