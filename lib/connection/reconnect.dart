import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class ReconnectScreen extends StatefulWidget {
  final String accnumber;
  final String name;
  final String address;
  final String meterno;
  final String lastpay;
  final double closingb;
  final int lastpayamt;
  final String dropdownValue;
  final String geolat;
  final String geolong;
  final String id;
  const ReconnectScreen({
    Key? key,
    required this.accnumber,
    required this.name,
    required this.address,
    required this.meterno,
    required this.lastpay,
    required this.closingb,
    required this.lastpayamt,
    required this.dropdownValue,
    required this.geolat,
    required this.geolong,
    required this.id,
  }) : super(key: key);

  @override
  State<ReconnectScreen> createState() => _ReconnectScreenState();
}

class _ReconnectScreenState extends State<ReconnectScreen> {
  final key = GlobalKey<FormState>();

  String dropdownValue = 'Select Reason';
  bool valuefirst = false;

  TextEditingController noticeno = TextEditingController();
  TextEditingController commentB = TextEditingController();

  String phpurl =
      'https://kadunaelectric.com/meterreading/kecs/tracking_write.php';

  bool _isLoading = false;
  late bool error, sending, success;
  late String msg;

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
      "reason": dropdownValue,
      "noticeserved": valuefirst.toString(),
      "id": widget.id,
      "lat": widget.geolat,
      "long": widget.geolong,
      "comment": commentB.text,
      "noticenumber": noticeno.text,
    }); //sending post request with header data

    if (res.statusCode == 200) {
      debugPrint(res.body); //print raw response on console
      var data = json.decode(res.body); //decoding json to array
      if (data["error"]) {
        setState(() {
          //refresh the UI when error is recieved from server
          sending = false;
          error = true;
          msg = data["message"]; //error message from server
        });
      } else {
        showMessage('Data Submitted Succesfully');
        //after write success, make fields empty

        setState(() {
          sending = false;
          success = true; //mark success and refresh UI with setState
        });
      }
    } else {
      //there is error
      setState(() {
        error = true;
        msg = "Error during sending data.";
        sending = false;
        //mark error and refresh UI with setState
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            AppBar(
              title: const Text('Bill Distribution'),
            ),
            Form(
              key: key,
              child: Padding(
                padding: const EdgeInsets.all(19.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                        padding: EdgeInsets.only(top: 0.0),
                        child: Center(
                            child: SizedBox(
                          width: 200,
                          height: 70,
                        ))),
                    // dropDown(),
                    // const SizedBox(height: 10.0),
                    noticenumber(),
                    const SizedBox(height: 10.0),
                    comment(),
                    const Padding(padding: EdgeInsets.all(5.0)),
                    checkbox(),
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
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          if (key.currentState!.validate()) {
                            _isLoading ? null : sendData();
                          }
                        }),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget comment() {
    return Material(
      child: TextFormField(
        controller: commentB,
        keyboardType: TextInputType.multiline,
        decoration: decorate("Comment"),
        maxLines: 8,
      ),
    );
  }

  Widget dropDown() {
    return DropdownButtonFormField<String>(
      decoration: decorate(''),
      value: dropdownValue,
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>[
        'Select Reason',
        'Customer Refused',
        'Premises locked',
        'Wrong Billing Address',
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

  Widget checkbox() {
    return Column(children: <Widget>[
      Row(children: <Widget>[
        const SizedBox(
          width: 10,
        ),
        const Text(
          'Notice Served: ',
          style: TextStyle(fontSize: 17.0),
        ),
        Checkbox(
          checkColor: Colors.greenAccent,
          activeColor: Colors.green,
          value: valuefirst,
          onChanged: (bool? value) {
            setState(() {
              valuefirst = value!;
            });
          },
        ),
      ])
    ]);
  }

  Widget noticenumber() {
    BorderRadius.circular(30.0);

    return Material(
      child: TextFormField(
        validator: validateField,
        controller: noticeno,
        keyboardType: TextInputType.text,
        decoration: decorate("Notice Number"),
      ),
    );
  }

  String? validateField(value) {
    if (value.isEmpty) {
      return "field is required";
    }
    return null;
  }

  String? validateD(value) {
    if (value == 'Select Reason') {
      return "field is required";
    }
    return null;
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

  InputDecoration decorate(String label) {
    return InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(),
        ));
  }
}
