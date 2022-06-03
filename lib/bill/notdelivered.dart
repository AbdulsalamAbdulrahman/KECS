import 'package:flutter/material.dart';

class NotDelivered extends StatelessWidget {
  static String routeName = "/NotDelivered";

  const NotDelivered({Key? key, required String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: NotDeliveredScreen(title: ''),
    );
  }
}

class NotDeliveredScreen extends StatefulWidget {
  const NotDeliveredScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<NotDeliveredScreen> createState() => _NotDeliveredScreenState();
}

class _NotDeliveredScreenState extends State<NotDeliveredScreen> {
  final key = GlobalKey<FormState>();
  String dropdownValue = 'Select Reason';

  @override
  Widget build(BuildContext context) {
    return Material(
        color: const Color.fromARGB(0, 224, 223, 223),
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
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
                  dropDown(),
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
          ],
        ));
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
