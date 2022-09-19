import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kecs/tracking/paid.dart';
import 'package:kecs/tracking/unpaid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NonPPM extends StatelessWidget {
  const NonPPM({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: NonPPMScreen(),
      // appBar: AppBar(),
    );
  }
}

class NonPPMScreen extends StatefulWidget {
  const NonPPMScreen({Key? key}) : super(key: key);

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
  int lastpayamt = 0;

  String dropdownValue = 'Select Status';

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

    if (jsondata != "Invalid Account Number") {
      String name = jsondata[0]['customerName'];
      String address = jsondata[0]['customerAddress'];
      String accnumber = jsondata[0]['customerAccountNo'];
      String meterno = jsondata[0]['meterNumber'];
      String lastpay = jsondata[0]['lastPaymentDate'];
      double closingb = jsondata[0]['closingBalance'];
      int lastpayamt = jsondata[0]['lastPaymentAmount'];

      setState(() {
        for (var i = 0; i < jsondata.length; i++) {
          var history = jsondata[i]['monthYear'];
          print(history);
        }
      });

      SharedPreferences prefNonPPM = await SharedPreferences.getInstance();
      await prefNonPPM.setString('name', name);
      await prefNonPPM.setString('address', address);
      await prefNonPPM.setString('accnumber', accnumber);
      await prefNonPPM.setString('meterno', meterno);
      await prefNonPPM.setString('lastpay', lastpay);
      await prefNonPPM.setDouble('closingb', closingb);
      await prefNonPPM.setInt('lastpayamt', lastpayamt);

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
    SharedPreferences prefNonPPM = await SharedPreferences.getInstance();
    setState(() {
      name = prefNonPPM.getString("name")!;
      address = prefNonPPM.getString("address")!;
      accnumber = prefNonPPM.getString("accnumber")!;
      meterno = prefNonPPM.getString("meterno")!;
      lastpay = prefNonPPM.getString("lastpay")!;
      closingb = prefNonPPM.getDouble("closingb")!;
      lastpayamt = prefNonPPM.getInt("lastpayamt")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Material(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                AppBar(
                  title: const Text('Tracking(Non PPM)'),
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
                                  if (dropdownValue == 'Paid') {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Paid()));
                                  } else if (dropdownValue == 'Unpaid') {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Unpaid()));
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
                      // getCred();
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
                const Padding(padding: EdgeInsets.all(5.0)),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => FullScreenDialog(),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                  child: const Text("View 6 month history"),
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

class FullScreenDialog extends StatelessWidget {
  const FullScreenDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: const Color(0xFF6200EE),
        title: const Text('Six(6) Month History'),
      ),
      body: Center(
        child: Text(""),
      ),
    );
  }
}
