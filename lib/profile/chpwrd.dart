import 'package:flutter/material.dart';
// import 'dart:convert';
import 'dart:async';
// import 'package:http/http.dart' as http;

class ChangeP extends StatefulWidget {
  final String id;
  final String phonenumber;
  final String payrollid;

  const ChangeP(
      {Key? key,
      required this.id,
      required this.phonenumber,
      required this.payrollid})
      : super(key: key);

  @override
  State<ChangeP> createState() => _ChangePState();
}

class _ChangePState extends State<ChangeP> {
  final key = GlobalKey<FormState>();

  String phpurl = 'https://kadunaelectric.com/meterreading/kecs/profile.php';

  // bool _isLoading = false;
  // final bool _isLoadingP = false;

  late bool error, sending, success;
  late String msg;

  TextEditingController confirmold = TextEditingController();
  TextEditingController newP = TextEditingController();
  TextEditingController confirmnew = TextEditingController();

  // Future getOldPassword() async {
  //   Uri url =
  //       Uri.parse('https://kadunaelectric.com/meterreading/kecs/cpwrd.php');

  //   var data = {
  //     "id": widget.id,
  //     'password': confirmold.text,
  //   };

  //   var response = await http.post(
  //     url,
  //     body: json.encode(data),
  //   );

  //   if (response.statusCode == 200) {
  //     // var jsondata = json.decode(response.body);
  //     // print(response.body);
  //     // setState(() {});

  //     // setState(() {});
  //   }
  // }

  // Future updatePassword() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   var res = await http.post(Uri.parse(phpurl), body: {
  //     "id": widget.id,
  //     "password": confirmnew.text,
  //   }); //sending post request with header data

  //   if (res.statusCode == 200) {
  //     debugPrint(res.body); //print raw response on console
  //     var data = json.decode(res.body); //decoding json to array
  //     if (data["error"]) {
  //       setState(() {
  //         //refresh the UI when error is recieved from server
  //         sending = false;
  //         error = true;
  //         msg = data["message"]; //error message from server
  //       });
  //     } else {
  //       showMessage('Data Submitted Succesfully');
  //       //after write success, make fields empty

  //       setState(() {
  //         sending = false;
  //         success = true; //mark success and refresh UI with setState
  //       });
  //     }
  //   } else {
  //     //there is error
  //     setState(() {
  //       error = true;
  //       msg = "Error during sending data.";
  //       sending = false;
  //       //mark error and refresh UI with setState
  //     });
  //   }
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Material(
          child: Column(
            children: <Widget>[
              AppBar(
                title: const Text('Profile Screen'),
              ),
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
                      // textFieldConfirmOld('Current Password', true),
                      // const SizedBox(height: 10.0),
                      // textFieldNew('New Password', true),
                      // const SizedBox(height: 10.0),
                      // textFieldConfirmNew('Confirm New Password', true),
                      // const SizedBox(height: 10.0),
                      buttonP()
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget textFieldConfirmOld(String text, _bool) {
    BorderRadius.circular(30.0);
    return Material(
      child: TextFormField(
        // initialValue: initial,
        enabled: _bool,
        controller: confirmold,
        keyboardType: TextInputType.text,
        decoration: decorate(text),
        validator: validateField,
      ),
    );
  }

  Widget textFieldNew(String text, _bool) {
    BorderRadius.circular(30.0);
    return Material(
      child: TextFormField(
        // initialValue: initial,
        enabled: _bool,
        controller: newP,
        keyboardType: TextInputType.text,
        decoration: decorate(text),
        validator: validateField,
      ),
    );
  }

  Widget textFieldConfirmNew(String text, _bool) {
    BorderRadius.circular(30.0);
    return Material(
      child: TextFormField(
        // initialValue: initial,
        enabled: _bool,
        controller: confirmnew,
        keyboardType: TextInputType.text,
        decoration: decorate(text),
        validator: validateField,
      ),
    );
  }

  Widget buttonP() {
    return const Center(
      child: Text('Coming Soon',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          )),
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

  String? validateOldPassword(value) {
    if (value.isEmpty) {
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
