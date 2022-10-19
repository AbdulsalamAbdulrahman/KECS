import 'package:flutter/material.dart';

class DisconnectScreen extends StatefulWidget {
  final String accnumber;
  final String name;
  final String address;
  final String meterno;
  final String lastpay;
  final double closingb;
  final int lastpayamt;
  final String dropdownValue;
  final String geolat;
  final String geolong;
  final String id;
  const DisconnectScreen({
    Key? key,
    required this.accnumber,
    required this.name,
    required this.address,
    required this.meterno,
    required this.lastpay,
    required this.closingb,
    required this.lastpayamt,
    required this.dropdownValue,
    required this.geolat,
    required this.geolong,
    required this.id,
  }) : super(key: key);

  @override
  State<DisconnectScreen> createState() => _DisconnectScreenState();
}

class _DisconnectScreenState extends State<DisconnectScreen> {
  final key = GlobalKey<FormState>();
  String dropdownValue = 'Select Reason';
  bool valuefirst = false;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
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
                    dropDown(),
                    const SizedBox(height: 10.0),
                    noticenumber(),
                    const SizedBox(height: 10.0),
                    comment(),
                    const Padding(padding: EdgeInsets.all(5.0)),
                    checkbox(),
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

  Widget checkbox() {
    return Column(children: <Widget>[
      Row(children: <Widget>[
        const SizedBox(
          width: 10,
        ),
        const Text(
          'Notice Served: ',
          style: TextStyle(fontSize: 17.0),
        ),
        Checkbox(
          checkColor: Colors.greenAccent,
          activeColor: Colors.green,
          value: valuefirst,
          onChanged: (bool? value) {
            setState(() {
              valuefirst = value!;
            });
          },
        ),
      ])
    ]);
  }

  Widget noticenumber() {
    BorderRadius.circular(30.0);

    return Material(
      child: TextFormField(
        keyboardType: TextInputType.text,
        decoration: decorate("Notice Number"),
      ),
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
