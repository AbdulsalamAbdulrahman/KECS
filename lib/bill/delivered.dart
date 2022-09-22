import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class Delivered extends StatelessWidget {
  const Delivered({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Delivered'),
      ),
      body: const Delivered(),
    );
  }
}

class DeliveredScreen extends StatefulWidget {
  final String dropdownValue;

  const DeliveredScreen({Key? key, required this.dropdownValue})
      : super(key: key);

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

  String name = '';
  String address = "";
  String accnumber = '';
  String meterno = "";
  String lastpay = "";
  double closingb = 0;
  int lastpayamt = 0;

  @override
  void initState() {
    super.initState();
    getCred();
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

  Future sendData() async {
    setState(() {
      _isLoading = true;
    });
    var res = await http.post(Uri.parse(phpurl), body: {
      "fullname": name,
      "address": address,
      "accnumber": accnumber,
      "meterno": meterno,
      "lastpay": lastpay,
      "status": widget.dropdownValue,
      "recipient": dropdownValue2,
      "recipientname": recipientN.text,
      "recipientphone": recipientP.text,
      "comment": commentC.text,
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
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Material(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                AppBar(
                  // automaticallyImplyLeading: false,
                  title: const Text('Bill Delivered'),
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
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              if (key.currentState!.validate()) {
                                SharedPreferences prefDelivered =
                                    await SharedPreferences.getInstance();
                                await prefDelivered.clear();

                                _isLoading ? null : sendData();
                              }
                            }),
                      ],
                    ),
                  ),
                ),
              ],
            ))
      ],
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
        validator: validateField,
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
