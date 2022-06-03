import 'package:flutter/material.dart';

class Delivered extends StatelessWidget {
  static String routeName = "/Delivered";

  const Delivered({Key? key, required String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Delivered'),
      ),
      body: const DeliveredScreen(title: ''),
    );
  }
}

class DeliveredScreen extends StatefulWidget {
  const DeliveredScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<DeliveredScreen> createState() => _DeliveredScreenState();
}

class _DeliveredScreenState extends State<DeliveredScreen> {
  final key = GlobalKey<FormState>();
  String dropdownValue = 'Select Recipient';

  @override
  Widget build(BuildContext context) {
    return Material(
        color: const Color.fromARGB(0, 224, 223, 223),
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
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
                    description(),
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

  Widget recipient() {
    BorderRadius.circular(30.0);

    return Material(
      child: TextFormField(
        keyboardType: TextInputType.text,
        decoration: decorate("Recipient Name"),
      ),
    );
  }

  Widget recipient1() {
    return Material(
      child: TextFormField(
        keyboardType: TextInputType.phone,
        decoration: decorate("Recipient Phone"),
      ),
    );
  }

  Widget description() {
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

  InputDecoration decorate(String label) {
    return InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(),
        ));
  }
}
