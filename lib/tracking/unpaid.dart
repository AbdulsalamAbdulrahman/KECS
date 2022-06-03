import 'package:flutter/material.dart';

class Unpaid extends StatelessWidget {
  static String routeName = "/Unpaid";

  const Unpaid({Key? key, required String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Unpaid'),
      ),
      body: const UnpaidScreen(title: ''),
    );
  }
}

class UnpaidScreen extends StatefulWidget {
  const UnpaidScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<UnpaidScreen> createState() => _UnpaidScreenState();
}

class _UnpaidScreenState extends State<UnpaidScreen> {
  final key = GlobalKey<FormState>();
  String dropdownValue = 'Select Reason';

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Bill Unpaid'),
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
                    dropDown(),
                    const SizedBox(height: 10.0),
                    comment(),
                    const Padding(padding: EdgeInsets.all(5.0)),
                    ElevatedButton(
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget comment() {
    return Material(
      child: TextFormField(
        keyboardType: TextInputType.phone,
        decoration: decorate("Comment"),
        maxLines: 8,
      ),
    );
  }

  Widget dropDown() {
    return DropdownButtonFormField<String>(
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

  InputDecoration decorate(String label) {
    return InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(),
        ));
  }
}
