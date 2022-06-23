import 'package:flutter/material.dart';

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
                      textField('Name'),
                      const SizedBox(height: 10.0),
                      textField('Phone'),
                      const SizedBox(height: 10.0),
                      textField('Payroll ID'),
                      const SizedBox(height: 10.0),
                      button('Update Profile'),
                      const SizedBox(height: 10.0),
                      button('Change Password')
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

  Widget textField(String text) {
    BorderRadius.circular(30.0);
    return Material(
      child: TextFormField(
        keyboardType: TextInputType.text,
        decoration: decorate(text),
      ),
    );
  }

  Widget button(String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(500, 50),
        maximumSize: const Size(500, 50),
      ),
      child: Container(
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
      ),
      onPressed: () {},
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
