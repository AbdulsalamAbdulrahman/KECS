import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:kecs/profile/chpwrd.dart';

class ProfileScreen extends StatefulWidget {
  final String fullname;
  final String id;
  final String phonenumber;
  final String payrollid;
  final dynamic emaill;

  const ProfileScreen(
      {Key? key,
      required this.fullname,
      required this.id,
      required this.phonenumber,
      this.emaill,
      required this.payrollid})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final key = GlobalKey<FormState>();

  String phpurl = 'https://kadunaelectric.com/meterreading/kecs/profile.php';

  bool _isLoading = false;
  final bool _isLoadingP = false;

  late bool error, sending, success;
  late String msg;

  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentProfile();
  }

  Future updateProfile() async {
    setState(() {
      _isLoading = true;
    });
    var res = await http.post(Uri.parse(phpurl), body: {
      "id": widget.id,
      "email": email.text,
      "name": name.text,
      "phone": phone.text,
    }); //sending post request with header data

    if (res.statusCode == 200) {
      //debugPrint(res.body); //print raw response on console
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
    getCurrentProfile();
    setState(() {
      _isLoading = false;
    });
  }

  Future getCurrentProfile() async {
    Uri url = Uri.parse(
        'https://kadunaelectric.com/meterreading/kecs/profile_update.php');

    var data = {
      'username': widget.payrollid,
    };

    var response = await http.post(
      url,
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);

      String updatedEmail = jsondata["email"];
      String updatedName = jsondata["name"];
      String updatedPhone = jsondata["phone"];

      setState(() {
        email.text = updatedEmail;
        name.text = updatedName;
        phone.text = updatedPhone;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Material(
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
                        textFieldN('Name', true),
                        const SizedBox(height: 10.0),
                        textFieldP('Phone', true),
                        const SizedBox(height: 10.0),
                        textFieldE('Email', true),
                        const SizedBox(height: 10.0),
                        textField('Payroll ID', widget.payrollid, false),
                        const SizedBox(height: 10.0),
                        button(),
                        const SizedBox(height: 10.0),
                        buttonP()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget textField(String text, String initialValue, _bool) {
    BorderRadius.circular(30.0);
    return Material(
      child: TextFormField(
        // initialValue: initial,
        enabled: _bool,
        controller: TextEditingController(text: initialValue),
        keyboardType: TextInputType.text,
        decoration: decorate(text),
      ),
    );
  }

  Widget textFieldN(String text, _bool) {
    BorderRadius.circular(30.0);
    return Material(
      child: TextFormField(
        // initialValue: initial,
        enabled: _bool,
        controller: name,
        keyboardType: TextInputType.text,
        decoration: decorate(text),
        validator: validateField,
      ),
    );
  }

  Widget textFieldP(String text, _bool) {
    BorderRadius.circular(30.0);
    return Material(
      child: TextFormField(
        // initialValue: initial,
        enabled: _bool,
        controller: phone,
        keyboardType: TextInputType.number,
        decoration: decorate(text),
        validator: validateField,
      ),
    );
  }

  Widget textFieldE(String text, _bool) {
    BorderRadius.circular(30.0);
    return Material(
      child: TextFormField(
        // initialValue: initial,
        enabled: _bool,
        controller: email,
        keyboardType: TextInputType.text,
        decoration: decorate(text),
        validator: validateField,
      ),
    );
  }

  Widget button() {
    return ElevatedButton.icon(
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
          _isLoading ? '' : 'Update Profile',
          style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
        onPressed: () async {
          if (key.currentState!.validate()) {
            _isLoading ? null : updateProfile();
          }
        });
  }

  Widget buttonP() {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(500, 50),
          maximumSize: const Size(500, 50),
        ),
        icon: _isLoadingP
            ? const SizedBox(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
                height: 15.0,
                width: 15.0,
              )
            : const Text(''),
        label: Text(
          _isLoadingP ? '' : 'Change Password',
          style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
        onPressed: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChangeP(
                        id: widget.id,
                        phonenumber: widget.phonenumber,
                        payrollid: widget.payrollid,
                      )));
        });
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
                // Navigator.of(context).pop();
                getCurrentProfile();
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

  InputDecoration decorate(String label) {
    return InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(),
        ));
  }
}
