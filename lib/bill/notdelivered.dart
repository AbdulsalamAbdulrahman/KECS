import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class NotDelivered extends StatelessWidget {
  const NotDelivered({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: NotDelivered(),
    );
  }
}

class NotDeliveredScreen extends StatefulWidget {
  final String dropdownValue;
  final String geolat;
  final String geolong;
  const NotDeliveredScreen(
      {Key? key,
      required this.dropdownValue,
      required this.geolat,
      required this.geolong})
      : super(key: key);

  @override
  State<NotDeliveredScreen> createState() => _NotDeliveredScreenState();
}

class _NotDeliveredScreenState extends State<NotDeliveredScreen> {
  final key = GlobalKey<FormState>();
  String dropdownValue = 'Select Reason';

  String phpurl = 'https://kadunaelectric.com/meterreading/kecs/write_bill.php';

  bool _isLoading = false;
  late bool error, sending, success;
  late String msg;

  String name = '';
  String address = "";
  String accnumber = '';
  String id = '';

  @override
  void initState() {
    super.initState();
    _getCred();
  }

  void _getCred() async {
    SharedPreferences prefBill = await SharedPreferences.getInstance();
    SharedPreferences prefLogin = await SharedPreferences.getInstance();

    setState(() {
      id = prefLogin.getString("id")!;
      name = prefBill.getString("name")!;
      address = prefBill.getString("address")!;
      accnumber = prefBill.getString("accnumber")!;
    });
  }

  Future sendData() async {
    setState(() {
      _isLoading = true;
    });

    var res = await http.post(Uri.parse(phpurl), body: {
      "fullname": name,
      "address": address,
      "accnumber": accnumber,
      "status": widget.dropdownValue,
      "reason": dropdownValue,
      "lat": widget.geolat,
      "long": widget.geolong,
      "id": id,
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
              // automaticallyImplyLeading: false,
              title: const Text('Bill Not Delivered'),
            ),
            Padding(
              padding: const EdgeInsets.all(19.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 50.0),
                  ),
                  const Text(
                    'Reason',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Form(
                      key: key,
                      child: Column(
                        children: [
                          dropDown(),
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
                                  debugPrint(
                                      name + address + widget.dropdownValue);

                                  _isLoading ? null : sendData();
                                }
                              }),
                        ],
                      ))
                ],
              ),
            ),
          ],
        ));
  }

  Widget dropDown() {
    return DropdownButtonFormField<String>(
      validator: validateField,
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
                // Navigator.of(context).pushAndRemoveUntil(
                //     MaterialPageRoute(builder: (context) => const BillScreen()),
                //     (route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  String? validateField(value) {
    if (value == 'Select Reason') {
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
