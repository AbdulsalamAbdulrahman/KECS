import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class TrackingScreen extends StatefulWidget {
  final String id;
  const TrackingScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final key = GlobalKey<FormState>();

  bool _isLoading = false;

  String meterno = '';
  String meternumber = "";
  dynamic accnum = 0;
  String name = '';
  String address = "";
  String feeder33 = "";
  String feeder11 = "";
  String regional = '';
  bool isMD = false;
  String llastdate = '';
  String llastamount = '';
  String dropdownValue = 'Select Status';

  @override
  void initState() {
    super.initState();
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

        dynamic myInt = int.parse(accno);

        setState(() {
          accnum = myInt;
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
      return showMessage('Network Error, Try again.');
    }
  }

  Future getLastPayment() async {
    Uri url = Uri.parse(
        'https://meterreading.kadunaelectric.com/kecs/searchpaymentresult.php?uid=$accnum');

    var response = await http.post(
      url,
      body: json.encode(accnum),
    );

    if (accnum == 0) {
      setState(() {
        _isLoading = false;
      });
    } else {
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
      appBar: AppBar(
        title: const Text('Tracking(PPM)'),
      ),
      body: ListView(children: <Widget>[
        Material(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Wrap(
                  children: <Widget>[
                    card(),
                    card1(),
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
                    keyboardType: TextInputType.number,
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
                    _isLoading ? '' : 'Search Meter',
                    style: const TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    if (key.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      key.currentState!.save();
                      _isLoading ? null : getMeterInfo();
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
                    container('Area Office:', regional),
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
