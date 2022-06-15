import 'package:back_pressed/back_pressed.dart';
import 'package:flutter/material.dart';
import 'package:kecs/dashboard/dashboard.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ProfileScreen(),
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

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        child: OnBackPressed(
          perform: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/Dashboard', (Route<dynamic> route) => false);
            Navigator.of(context).pop();

            // debugPrint('The back button on the device was pressed');
          },
          child: Column(
            children: [
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
                      recipient('Name'),
                      const SizedBox(height: 10.0),
                      recipient('Phone number'),
                      const Padding(padding: EdgeInsets.all(5.0)),
                      recipient('Payroll ID'),
                      const SizedBox(height: 10.0),
                      button(context, 'Update Profile'),
                      const Padding(padding: EdgeInsets.all(5.0)),
                      button(context, 'Change Password'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

Widget recipient(String text) {
  BorderRadius.circular(30.0);
  return Material(
    child: TextFormField(
      keyboardType: TextInputType.text,
      decoration: decorate(text),
    ),
  );
}

Widget button(BuildContext context, String text) {
  return ElevatedButton(
    child: Container(
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
      ),
    ),
    onPressed: () {
      Navigator.of(context).pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Dashboard()));
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
