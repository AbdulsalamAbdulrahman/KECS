import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kecs/dashboard/dashboardscreen1.dart';
import 'package:kecs/dashboard/dashboardscreen2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kecs/dashboard/dashboard.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final key = GlobalKey<FormState>();
  String username = '';
  String password = '';

  bool _isObscure = true;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Form(
        key: key,
        child: Padding(
          padding: const EdgeInsets.all(19.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Center(
                      child: SizedBox(
                          width: 200,
                          height: 70,
                          child: Image.asset('kecs.png')))),
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
                    key.currentState!.save();
                    _isLoading ? null : userLogin();
                  }
                },
              ),
              TextButton(
                  onPressed: () {}, child: const Text('Forgot Password?'))
            ],
          ),
        ),
      ),
    );
  }

  Widget user() {
    BorderRadius.circular(30.0);

    return Material(
      child: TextFormField(
        keyboardType: TextInputType.text,
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

    Uri url =
        Uri.parse('https://kadunaelectric.com/meterreading/mobile_login.php');

    var data = {
      'username': username,
      'password': password,
    };

    var response = await http.post(
      url,
      body: json.encode(data),
    );
    var jsondata = json.decode(response.body);

    // SharedPreferences pref = await SharedPreferences.getInstance();
    // await pref.setString('username', username);

    // debugPrint(username);

    // SharedPreferences pref = await SharedPreferences.getInstance();
    // await pref.setString('login', jsondata);

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      debugPrint(response.body);

      String fullname = jsondata["fullname"];
      String jobtitle = jsondata["jobtitle"];
      String payrollid = jsondata["payrollid"];
      String areaoffice = jsondata["areaoffice"];
      String feeder = jsondata["feeder"];
      String phonenumber = jsondata["phonenumber"];

      // debugPrint(fullname);
      // debugPrint(jobtitle);
      // debugPrint(payrollid);
      // debugPrint(areaoffice);
      // debugPrint(feeder);
      // debugPrint(phonenumber);

      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('fullname', fullname);

      await pref.setString('jobtitle', jobtitle);
      await pref.setString('payrollid', payrollid);
      await pref.setString('areaoffice', areaoffice);
      await pref.setString('feeder', feeder);
      await pref.setString('phonenumber', phonenumber);

      if (jobtitle == "SalesRep") {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Dashboard()));
      } else if (jobtitle == "Reader") {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Dashboard1()));
      } else if (jobtitle == "Disconnection") {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Dashboard2()));
      }

      // String jobtitle = jsondata["jobtitle"];
      // String areaoffice = jsondata["areaoffice"];
      // String payrollid = jsondata["payrollid"];

      // SharedPreferences pref = await SharedPreferences.getInstance();
      // await pref.setString('fullname', fullname);
      // await pref.setString('jobtitle', jobtitle);
      // await pref.setString('areaoffice', areaoffice);
      // await pref.setString('payrollid', payrollid);

      // debugPrint(jobtitle);
      // debugPrint(areaoffice);
      // debugPrint(payrollid);

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
