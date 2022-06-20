import 'package:flutter/material.dart';

class Delivered extends StatelessWidget {
  const Delivered({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Delivered'),
      ),
      body: const Delivered(),
    );
  }
}

class DeliveredScreen extends StatefulWidget {
  const DeliveredScreen({Key? key}) : super(key: key);

  @override
  State<DeliveredScreen> createState() => _DeliveredScreenState();
}

class _DeliveredScreenState extends State<DeliveredScreen> {
  final key = GlobalKey<FormState>();
  String dropdownValue = 'Select Recipient';

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
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
                    comment(),
                    const Padding(padding: EdgeInsets.all(5.0)),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(500, 50),
                        maximumSize: const Size(500, 50),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
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

  Widget comment() {
    return Material(
      child: TextFormField(
        keyboardType: TextInputType.multiline,
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
