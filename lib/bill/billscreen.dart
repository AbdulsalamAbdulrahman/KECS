import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kecs/bill/delivered.dart';
import 'package:kecs/bill/notdelivered.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bill extends StatelessWidget {
  const Bill({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BillScreen(),
      // appBar: AppBar(),
    );
  }
}

class BillScreen extends StatefulWidget {
  const BillScreen({Key? key}) : super(key: key);

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
  int lastpayamt = 0;
  String geolat = '';
  String geolong = '';

  String dropdownValue = 'Select Status';

  Future _initLocationService() async {
    var location = Location();

    if (!await location.serviceEnabled()) {
      if (!await location.requestService()) {
        return;
      }
    }

    var permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission != PermissionStatus.granted) {
        return;
      }
    }

    var loc = await location.getLocation();
    var lat = loc.latitude.toString();
    var long = loc.longitude.toString();

    print("${loc.latitude} ${loc.longitude}");

    setState(() {});
    geolat = lat;
    geolong = long;
  }

  Future getAccNo() async {
    setState(() {
      _isLoading = true;
    });

    Uri url = Uri.parse(
        'https://kadunaelectric.com/meterreading/kecs/dotnet_billinghistory.php?id=$accno');

    var data = {
      'accno': accno,
    };

    var response = await http.post(
      url,
      body: json.encode(data),
    );

    final jsondata = json.decode(response.body);

    final List<dynamic> dataList = jsonDecode(response.body);
    print(dataList[0]);
    print(dataList[1]);

    final item = dataList[0];
    print(item['monthYear']); // foo

    if (jsondata != "Invalid Account Number") {
      String name = jsondata[0]['customerName'];
      String address = jsondata[0]['customerAddress'];
      String accnumber = jsondata[0]['customerAccountNo'];
      String meterno = jsondata[0]['meterNumber'];
      String lastpay = jsondata[0]['lastPaymentDate'];
      double closingb = jsondata[0]['closingBalance'];
      int lastpayamt = jsondata[0]['lastPaymentAmount'];

      SharedPreferences prefBill = await SharedPreferences.getInstance();
      await prefBill.setString('name', name);
      await prefBill.setString('address', address);
      await prefBill.setString('accnumber', accnumber);
      await prefBill.setString('meterno', meterno);
      await prefBill.setString('lastpay', lastpay);
      await prefBill.setDouble('closingb', closingb);
      await prefBill.setInt('lastpayamt', lastpayamt);

      getCred();
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

  void getCred() async {
    SharedPreferences prefBill = await SharedPreferences.getInstance();
    setState(() {
      name = prefBill.getString("name")!;
      address = prefBill.getString("address")!;
      accnumber = prefBill.getString("accnumber")!;
      meterno = prefBill.getString("meterno")!;
      lastpay = prefBill.getString("lastpay")!;
      closingb = prefBill.getDouble("closingb")!;
      lastpayamt = prefBill.getInt("lastpayamt")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      // scrollDirection: Axis.vertical,
      children: <Widget>[
        Material(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                AppBar(
                  title: const Text('Bill Distribution'),
                ),
                Wrap(
                  children: [
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
                                  if (dropdownValue == 'Delivered') {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DeliveredScreen(
                                                  dropdownValue: dropdownValue,
                                                  geolat: geolat,
                                                  geolong: geolong,
                                                )));
                                  } else if (dropdownValue == 'Not Delivered') {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NotDeliveredScreen(
                                                  dropdownValue: dropdownValue,
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
                      _isLoading ? null : getAccNo();
                      _initLocationService();
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
                container3('Last Payment Amount:', lastpayamt),
                container2('Closing Balance:', closingb),
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
        children: [
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
        children: [
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
        children: [
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

  InputDecoration decorate(String label) {
    return InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(),
        ));
  }
}
