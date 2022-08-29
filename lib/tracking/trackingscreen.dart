import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kecs/tracking/paid.dart';
import 'package:kecs/tracking/unpaid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final key = GlobalKey<FormState>();

  bool _isLoading = false;

  String meterno = '';
  String meternumber = "";
  String accno = "";
  String name = '';
  String address = "";
  String tariff = "";
  String feeder = "";
  String areaofficeppm = '';
  String lastdate = '';
  String lastamount = '';
  String dropdownValue = 'Select Status';

  Future getMeterInfo() async {
    setState(() {
      _isLoading = true;
    });

    Uri url =
        Uri.parse('https://kadunaelectric.com/meterreading/kecs/tracking.php');

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
      debugPrint(response.body);

      String name = jsondata['name'];
      String address = jsondata['address'];
      String accno = jsondata['accno'];
      String meternumber = jsondata['meterno'];
      String tariff = jsondata['tariff'];
      String feeder = jsondata['feeder'];
      String areaofficeppm = jsondata['areaofficeppm'];

      SharedPreferences prefPPM = await SharedPreferences.getInstance();
      await prefPPM.setString('name', name);
      await prefPPM.setString('address', address);
      await prefPPM.setString('accno', accno);
      await prefPPM.setString('meternumber', meternumber);
      await prefPPM.setString('tariff', tariff);
      await prefPPM.setString('feeder', feeder);
      await prefPPM.setString('areaofficeppm', areaofficeppm);

      getCredppm();
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

  Future getLastPayment() async {
    Uri url = Uri.parse(
        'https://kadunaelectric.com/meterreading/kecs/searchpaymentresult.php?AccountNumber=$meterno');

    var data = {
      'meterno': meterno,
    };

    var response = await http.post(
      url,
      body: json.encode(data),
    );

    var jsondata = json.decode(response.body);

    if (jsondata != "Invalid Meter Number") {
      final jsondata = json.decode(response.body);
      debugPrint(response.body);
      String lastdate = jsondata['lastdate'];
      String lastamount = jsondata['lastamount'];

      SharedPreferences prefPPM = await SharedPreferences.getInstance();
      await prefPPM.setString('lastdate', lastdate);
      await prefPPM.setString('lastamount', lastamount);

      getCredppm();
    }
  }

  void getCredppm() async {
    SharedPreferences prefPPM = await SharedPreferences.getInstance();
    setState(() {
      name = prefPPM.getString("name")!;
      address = prefPPM.getString("address")!;
      accno = prefPPM.getString("accno")!;
      meternumber = prefPPM.getString("meternumber")!;
      tariff = prefPPM.getString("tariff")!;
      feeder = prefPPM.getString("feeder")!;
      areaofficeppm = prefPPM.getString("areaofficeppm")!;
      lastdate = prefPPM.getString("lastdate")!;
      lastamount = prefPPM.getString("lastamount")!;
    });
  }

  // void getCredppmm() async {
  //   SharedPreferences prefPPM = await SharedPreferences.getInstance();
  //   setState(() {
  //     lastdate = pref.getString("lastdate")!;
  //     lastamount = pref.getString("lastamount")!;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      Material(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              AppBar(
                title: const Text('Tracking(PPM)'),
              ),
              Wrap(
                children: [
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
                                          builder: (context) => const Paid()));
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
    ]);
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
                      getLastPayment();
                      _isLoading ? null : getMeterInfo();

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
                Wrap(
                  textDirection: TextDirection.ltr,
                  verticalDirection: VerticalDirection.down,
                  direction: Axis.vertical,
                  alignment: WrapAlignment.start,
                  children: [
                    container('Name: ', name),
                    container('Address: ', address),
                    container('Meter Number:', meternumber),
                    container('Account Number:', accno),
                    container('Tariff:', tariff),
                    container('Feeder:', feeder),
                    container('Area Office:', areaofficeppm),
                    container('Last Vending Date:', lastdate),
                    container('Last Amount Vended:', lastamount),
                    dropDown(),
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
