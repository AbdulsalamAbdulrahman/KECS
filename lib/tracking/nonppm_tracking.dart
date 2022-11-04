import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kecs/tracking/paid.dart';
import 'package:kecs/tracking/unpaid.dart';
import 'package:geolocator/geolocator.dart';

class NonPPMScreen extends StatefulWidget {
  final String id;
  const NonPPMScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<NonPPMScreen> createState() => _NonPPMScreenState();
}

class _NonPPMScreenState extends State<NonPPMScreen> {
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

  List dataList1 = [];

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
          debugPrint('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          debugPrint("'Location permissions are permanently denied");
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
      debugPrint("GPS Service is not enabled, turn on GPS location");
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

    // debugPrint("$long, $lat");

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

    var data = {
      'accno': accno,
    };

    var response = await http.post(
      url,
      body: json.encode(data),
    );

    final jsondata = json.decode(response.body);

    final List<dynamic> dataList = jsonDecode(response.body);
    // List.generate(0, (index) => {print(dataList[index])});

    setState(() {
      dataList1 = dataList;
    });

    if (jsondata != "Invalid Account Number") {
      String namejson = jsondata[0]['customerName'];
      String addressjson = jsondata[0]['customerAddress'];
      String accnumberjson = jsondata[0]['customerAccountNo'];
      String meternojson = jsondata[0]['meterNumber'];
      String lastpayjson = jsondata[0]['lastPaymentDate'];
      double closingbjson = jsondata[0]['closingBalance'];
      double lastpayamtjson = jsondata[0]['lastPaymentAmount'];

      setState(() {
        accnumber = accnumberjson;
        name = namejson;
        address = addressjson;
        meterno = meternojson;
        lastpay = lastpayjson;
        closingb = closingbjson;
        lastpayamt = lastpayamtjson;
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

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracking(Non PPM)'),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Material(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Wrap(
                    children: <Widget>[
                      // listView()
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
                            onPressed: name == ""
                                ? null
                                : () {
                                    if (dropdownValue == 'Paid') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => PaidScreen(
                                                    accnumber: accnumber,
                                                    name: name,
                                                    address: address,
                                                    meterno: meterno,
                                                    lastpay: lastpay,
                                                    closingb: closingb,
                                                    lastpayamt: lastpayamt,
                                                    dropdownValue:
                                                        dropdownValue,
                                                    geolat: geolat,
                                                    geolong: geolong,
                                                    id: widget.id,
                                                  )));
                                    } else if (dropdownValue == 'Unpaid') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UnpaidScreen(
                                                    accnumber: accnumber,
                                                    name: name,
                                                    address: address,
                                                    meterno: meterno,
                                                    lastpay: lastpay,
                                                    closingb: closingb,
                                                    lastpayamt: lastpayamt,
                                                    dropdownValue:
                                                        dropdownValue,
                                                    geolat: geolat,
                                                    geolong: geolong,
                                                    id: widget.id,
                                                  )));
                                    }
                                  },
                            child: const Text('Continue')),
                      ),
                    ],
                  )
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
                    keyboardType: TextInputType.text,
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
                      _isLoading ? null : getAccNo();
                      getLocation();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(500, 50),
                    maximumSize: const Size(500, 50),
                  ),
                  // child: const Text(
                  //   'Search',
                  //   style:
                  //       TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  // ),
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
                container('Name: ', name),
                container('Address: ', address),
                container('Account Number:', accnumber),
                container('Meter Number:', meterno),
                container('Last Payment Date:', lastpay),
                // container3('Last Payment Amount:', lastpayamt),
                container2('Closing Balance:', closingb),
                const Padding(padding: EdgeInsets.all(5.0)),
                OutlinedButton(
                  onPressed: dataList1.isEmpty
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  FullScreenDialog(
                                dataList1: dataList1,
                              ),
                              fullscreenDialog: true,
                            ),
                          );
                        },
                  child: const Text("View monthly payment history"),
                ),
                dropDown(),
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

  // Widget container3(text, int text1) {
  //   return Container(
  //     padding: const EdgeInsets.only(top: 10),
  //     decoration: BoxDecoration(border: Border.all(color: Colors.white)),
  //     child: Row(
  //       children: <Widget>[
  //         Text(
  //           text,
  //           style: const TextStyle(fontWeight: FontWeight.bold),
  //         ),
  //         Text(
  //           text1,
  //           style: const TextStyle(fontWeight: FontWeight.normal),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
        'Paid',
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

  InputDecoration decorate(String label) {
    return InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(),
        ));
  }
}

class FullScreenDialog extends StatefulWidget {
  final List dataList1;
  const FullScreenDialog({
    Key? key,
    required this.dataList1,
  }) : super(key: key);

  @override
  State<FullScreenDialog> createState() => _FullScreenDialogState();
}

class _FullScreenDialogState extends State<FullScreenDialog> {
  final key = GlobalKey<FormState>();

  List dataList1 = [];

  @override
  Widget build(Object context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Monthly Payment History')),
        body: ListView.builder(
            itemCount: widget.dataList1.length,
            itemBuilder: (_, index) {
              // final item = dataList1[index];
              return Card(
                // this key is required to save and restore ExpansionTile expanded state
                key: PageStorageKey(widget.dataList1[index]),
                color: Colors.green,
                elevation: 4,
                child: ExpansionTile(
                  iconColor: Colors.white,
                  collapsedIconColor: Colors.white,
                  controlAffinity: ListTileControlAffinity.leading,
                  childrenPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  expandedCrossAxisAlignment: CrossAxisAlignment.end,
                  maintainState: true,
                  title: Text(
                    widget.dataList1[index]['monthYear'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  // contents
                  children: <Widget>[
                    Column(children: <Widget>[
                      Text(
                          "Last Paid Amount: ${widget.dataList1[index]['lastPaymentAmount'].toString()}",
                          style: const TextStyle(color: Colors.white)),
                      Text(
                          "Last Payment Date: ${widget.dataList1[index]['lastPaymentDate'].toString()}",
                          style: const TextStyle(color: Colors.white))
                    ])
                  ],
                ),
              );
            }));
  }
}
