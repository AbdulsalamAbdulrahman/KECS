import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class PaidScreen extends StatefulWidget {
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

  const PaidScreen(
      {Key? key,
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
      required this.id})
      : super(key: key);

  @override
  State<PaidScreen> createState() => _PaidScreenState();
}

class _PaidScreenState extends State<PaidScreen> {
  final key = GlobalKey<FormState>();

  String _experience = "Good";

  final List<String> _status1 = ["Good", "Average", "Bad"];

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
      "satisfaction": _experience,
      "id": widget.id,
      "lat": widget.geolat,
      "long": widget.geolong
    });

    if (res.statusCode == 200) {
      //debugPrint(res.body);
      var data = json.decode(res.body);
      if (data["error"]) {
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
      appBar: AppBar(title: const Text('Tracking Paid')),
      body: Material(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              const Padding(padding: EdgeInsets.only(top: 5.0)),
              Form(
                key: key,
                child: Padding(
                  padding: const EdgeInsets.all(19.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(top: 0.0),
                        child: Center(
                          child: SizedBox(
                            width: 200,
                            height: 100,
                          ),
                        ),
                      ),
                      // const Padding(padding: EdgeInsets.all(5.0)),
                      container1('Customer Experience'),
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
          )),
    );
  }

  Widget container1(String text) {
    return Wrap(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(border: Border.all(color: Colors.white)),
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        RadioGroup<String>.builder(
          direction: Axis.horizontal,
          groupValue: _experience,
          horizontalAlignment: MainAxisAlignment.spaceAround,
          onChanged: (value) => setState(() {
            _experience = value!;
          }),
          items: _status1,
          textStyle: const TextStyle(fontSize: 15),
          itemBuilder: (item) => RadioButtonBuilder(
            item,
          ),
        ),
      ],
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
