import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:kecs/login.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final key = GlobalKey<FormState>();

  String phpurl = 'https://kadunaelectric.com/meterreading/kecs/profile.php';

  String fullname = '';
  String payrollid = "";
  String phonenumber = '';
  String id = '';
  String emaill = '';

  bool _isLoading = false;
  final bool _isLoadingP = false;

  late bool error, sending, success;
  late String msg;

  TextEditingController email = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCred();
  }

  // @override
  // void dispose() {
  //   // dispose it here
  //   TextEditingController.dispose();
  //   super.dispose();
  // }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    SharedPreferences prefLogin = await SharedPreferences.getInstance();
    setState(() {
      id = prefLogin.getString("id")!;
      emaill = prefLogin.getString("emaill")!;
      fullname = pref.getString("fullname")!;
      payrollid = pref.getString("payrollid")!;
      phonenumber = pref.getString("phonenumber")!;
      email.text = emaill;
    });
  }

  Future updateData() async {
    setState(() {
      _isLoading = true;
    });
    var res = await http.post(Uri.parse(phpurl), body: {
      "id": id,
      "email": email.text,
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
          child: Column(
            children: <Widget>[
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
                      textField('Name', fullname, true),
                      const SizedBox(height: 10.0),
                      textField('Phone', phonenumber, true),
                      const SizedBox(height: 10.0),
                      textFieldE('Email', true),
                      const SizedBox(height: 10.0),
                      textField('Payroll ID', payrollid, false),
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
            _isLoading ? null : updateData();
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
        onPressed: () async {});
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
