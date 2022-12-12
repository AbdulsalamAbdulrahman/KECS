import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kecs/dashboard/dashboardscreen1.dart';
import 'package:kecs/dashboard/dashboardscreen2.dart';
import 'package:kecs/dashboard/dashboardscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final key = GlobalKey<FormState>();

  String username = '';
  String password = '';

  String fullname = '';
  String jobtitle = '';
  String payrollid = '';
  String areaoffice = '';
  String feeder = '';
  String phonenumber = '';
  String id = '';
  dynamic emaill = '';

  bool _isObscure = true;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: key,
          child: Padding(
            padding: const EdgeInsets.all(19.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 390, child: Image.asset('logo-kecs.png')),
                user(),
                const SizedBox(height: 10.0),
                pass(),
                const SizedBox(height: 10.0),
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
                    _isLoading ? '' : 'Sign in',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(500, 50),
                    maximumSize: const Size(500, 50),
                  ),
                  onPressed: () {
                    if (key.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      key.currentState!.save();
                      _isLoading ? null : userLogin();
                    }
                  },
                ),
                // TextButton(
                //     onPressed: () {}, child: const Text('Forgot Password?'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget user() {
    BorderRadius.circular(30.0);

    return Material(
      child: TextFormField(
        keyboardType: TextInputType.number,
        onSaved: (value) => username = value.toString(),
        onChanged: (value) {
          if (value.isNotEmpty) {}
          // return null;
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "please enter your username";
          }
          return null;
        },
        decoration: decorate("Username", Icons.person, 'Phone Number'),
      ),
    );
  }

  Widget pass() {
    return TextFormField(
      keyboardType: TextInputType.text,
      obscureText: _isObscure,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: const Icon(Icons.lock),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isObscure ? Icons.visibility : Icons.visibility_off,
            color: Colors.green,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
      ),
      onSaved: (value) => password = value.toString(),
      onChanged: (value) {
        if (value.isNotEmpty) {}
        // return null;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "please enter your password";
        }
        return null;
      },
    );
  }

  Future userLogin() async {
    setState(() {
      _isLoading = true;
    });

    Uri url = Uri.parse(
        'https://kadunaelectric.com/meterreading/kecs/mobile_login.php');

    try {
      var data = {
        'username': username,
        'password': password,
      };

      var response = await http.post(
        url,
        body: json.encode(data),
      );
      var jsondata = json.decode(response.body);

      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);

        String fullname = jsondata["fullname"];
        String jobtitle = jsondata["jobtitle"];
        String payrollid = jsondata["payrollid"];
        String areaoffice = jsondata["areaoffice"];
        String feeder = jsondata["feeder"];
        String phonenumber = jsondata["phonenumber"];
        String id = jsondata["id"];
        dynamic emaill = jsondata['email'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user', phonenumber);

        setState(() {
          fullname = fullname;
          jobtitle = jobtitle;
          payrollid = payrollid;
          areaoffice = areaoffice;
          feeder = feeder;
          phonenumber = phonenumber;
          id = id;
          emaill = emaill;
        });

        if (jobtitle == "SalesRep") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DashboardScreen(
                        fullname: fullname,
                        jobtitle: jobtitle,
                        payrollid: payrollid,
                        areaoffice: areaoffice,
                        feeder: feeder,
                        phonenumber: phonenumber,
                        id: id,
                        emaill: emaill,
                      )));
        } else if (jobtitle == "Reader") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DashboardScreen1(
                        fullname: fullname,
                        jobtitle: jobtitle,
                        payrollid: payrollid,
                        areaoffice: areaoffice,
                        feeder: feeder,
                        phonenumber: phonenumber,
                        id: id,
                        emaill: emaill,
                      )));
        } else if (jobtitle == "Disconnection") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DashboardScreen2(
                        fullname: fullname,
                        jobtitle: jobtitle,
                        payrollid: payrollid,
                        areaoffice: areaoffice,
                        feeder: feeder,
                        phonenumber: phonenumber,
                        id: id,
                        emaill: emaill,
                      )));
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(jsondata, style: const TextStyle(color: Colors.red)),
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
    } catch (e) {
      //debugPrint('error');
      setState(() {
        _isLoading = false;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  InputDecoration decorate(String label, icon, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: const BorderSide(),
      ),
    );
  }
}
