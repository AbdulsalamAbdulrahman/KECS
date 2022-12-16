import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class Delivered extends StatelessWidget {
  const Delivered({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Delivered(),
    );
  }
}

class DeliveredScreen extends StatefulWidget {
  final String accnumber;
  final String name;
  final String address;
  final String meterno;
  final String lastpay;
  final double closingb;
  final double lastpayamt;
  final String dropdownValue;
  final String geolat;
  final String geolong;
  final String id;

  const DeliveredScreen({
    Key? key,
    required this.accnumber,
    required this.name,
    required this.dropdownValue,
    required this.geolat,
    required this.geolong,
    required this.address,
    required this.meterno,
    required this.lastpay,
    required this.closingb,
    required this.lastpayamt,
    required this.id,
  }) : super(key: key);

  @override
  State<DeliveredScreen> createState() => _DeliveredScreenState();
}

class _DeliveredScreenState extends State<DeliveredScreen> {
  final key = GlobalKey<FormState>();

  String phpurl = 'https://kadunaelectric.com/meterreading/kecs/write_bill.php';

  TextEditingController recipientN = TextEditingController();
  TextEditingController recipientP = TextEditingController();
  TextEditingController commentC = TextEditingController();

  String dropdownValue2 = 'Select Recipient';

  bool _isLoading = false;
  late bool error, sending, success;
  late String msg;

  @override
  void initState() {
    super.initState();
  }

  Future sendData() async {
    setState(() {
      _isLoading = true;
    });
    var res = await http.post(Uri.parse(phpurl), body: {
      "fullname": widget.name,
      "address": widget.address,
      "accnumber": widget.accnumber,
      "meterno": widget.meterno,
      "lastpay": widget.lastpay,
      "status": widget.dropdownValue,
      "recipient": dropdownValue2,
      "recipientname": recipientN.text,
      "recipientphone": recipientP.text,
      "comment": commentC.text,
      "id": widget.id,
      "lat": widget.geolat,
      "long": widget.geolong
    });

    if (res.statusCode == 200) {
      // debugPrint(res.body);
      var data = json.decode(res.body);
      if (data["message"] == 'Duplicate data') {
        showMessageD('Duplicate Data!!!');

        setState(() {
          sending = false;
          error = true;
          msg = data["message"];
        });
      } else {
        showMessage('Data Submitted Succesfully');

        setState(() {
          sending = false;
          success = true;
        });
      }
    } else {
      setState(() {
        error = true;
        msg = "Error during sending data.";
        sending = false;
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
        // automaticallyImplyLeading: false,
        title: const Text('Bill Delivered'),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Material(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Form(
                    key: key,
                    child: Padding(
                      padding: const EdgeInsets.all(19.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Padding(
                              padding: EdgeInsets.only(top: 0.0),
                              child: Center(
                                  child: SizedBox(
                                width: 200,
                                height: 70,
                              ))),
                          recipient(),
                          const SizedBox(height: 10.0),
                          recipient1(),
                          const Padding(padding: EdgeInsets.all(5.0)),
                          dropDown(),
                          const SizedBox(height: 10.0),
                          comment(),
                          const Padding(padding: EdgeInsets.all(5.0)),
                          ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(500, 50),
                                maximumSize: const Size(500, 50),
                              ),
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
                                _isLoading ? '' : 'Submit',
                                style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async {
                                if (key.currentState!.validate()) {
                                  if (widget.geolat != "" &&
                                      widget.geolong != "") {
                                    _isLoading ? null : sendData();
                                  } else {
                                    showMessageG(
                                        'Turn on phone location and permission. Submission cannot be processed!!!');
                                  }
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget recipient() {
    BorderRadius.circular(30.0);
    return Material(
      child: TextFormField(
        validator: validateField,
        controller: recipientN,
        keyboardType: TextInputType.text,
        decoration: decorate("Recipient Name"),
      ),
    );
  }

  Widget recipient1() {
    return Material(
      child: TextFormField(
        validator: validateField,
        controller: recipientP,
        keyboardType: TextInputType.phone,
        decoration: decorate("Recipient Phone"),
      ),
    );
  }

  Widget comment() {
    return Material(
      child: TextFormField(
        controller: commentC,
        keyboardType: TextInputType.multiline,
        decoration: decorate("Comment"),
        maxLines: 8,
      ),
    );
  }

  Widget dropDown() {
    return DropdownButtonFormField<String>(
      validator: validateD,
      decoration: decorate(''),
      value: dropdownValue2,
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue2 = newValue!;
        });
      },
      items: <String>[
        'Select Recipient',
        'Self',
        'Spouse',
        'Son',
        'Daughter',
        'Relative',
        'Worker',
        'Neighbour'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(fontSize: 15),
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
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> showMessageD(String msg) async {
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
                Navigator.of(context).pop();
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
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String? validateField(value) {
    if (value.isEmpty) {
      return "field is required";
    }
    return null;
  }

  String? validateD(value) {
    if (value == 'Select Recipient') {
      return "field is required";
    }
    return null;
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
