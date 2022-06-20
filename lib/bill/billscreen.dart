import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kecs/bill/delivered.dart';
import 'package:kecs/bill/notdelivered.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({Key? key}) : super(key: key);

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  final key = GlobalKey<FormState>();

  final TextEditingController _inputController = TextEditingController();

  String dropdownValue = 'Select Status';
  bool _visible = false;

  List _customers = [];

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/customer.json');
    final data = await json.decode(response);
    setState(() {
      _customers = data["customers"];
    });
  }

  void _toggle() {
    setState(() {
      _visible = !_visible;
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Material(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                AppBar(
                  title: const Text('Bill Distribution'),
                ),
                Wrap(
                  children: [
                    // const Padding(padding: EdgeInsets.all(20.0)),
                    card(),
                    card1(),
                    card2(),
                    const Padding(padding: EdgeInsets.all(5.0)),
                    Visibility(
                        visible: _visible,
                        child: ElevatedButton(
                            onPressed: () {
                              if (dropdownValue == 'Delivered') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const DeliveredScreen()));
                              } else if (dropdownValue == 'Not Delivered') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const NotDeliveredScreen()));
                              }
                            },
                            child: const Text('Continue')))
                  ],
                )
              ],
            ))
      ],
    );
  }

  Widget card() {
    return SizedBox(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Search Customer',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const Padding(padding: EdgeInsets.all(5.0)),
                Form(
                  child: TextFormField(
                    controller: _inputController,
                    keyboardType: TextInputType.text,
                    decoration: decorate('Account Number'),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(3.0)),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _inputController,
                  builder: (context, value, child) {
                    return ElevatedButton(
                      onPressed: value.text.isNotEmpty
                          ? () {
                              _toggle();
                              readJson;
                            }
                          : null,
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ]),
        ),
        elevation: 5,
        shadowColor: Colors.green,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
              color: Colors.green, style: BorderStyle.solid, width: 2.0),
        ),
      ),
    );
  }

  Widget card1() {
    return Visibility(
        visible: _visible,
        child: SizedBox(
          width: 500,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('Customer Billing Information',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    container(_customers, ''),
                    container('Address: ', ''),
                    container('Account Number:', ''),
                    container('Meter Number:', ''),
                    container('Last Payment Date:', ''),
                    container('Total Payment:', ''),
                    container('Total Billed Amount:', ''),
                    container('Closing Balance:', ''),
                    container('Latitude:', ''),
                    container('Longitude:', ''),
                    dropDown()
                  ]),
            ),
            elevation: 5,
            shadowColor: Colors.green,
            shape: const RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.green, style: BorderStyle.solid, width: 2.0),
            ),
          ),
        ));
  }

  Widget card2() {
    return Visibility(
        visible: _visible,
        child: SizedBox(
          width: 500,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('Payment Details',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    container('Last Vending:', ''),
                    container('Last Vending Date:', ''),
                  ]),
            ),
            elevation: 5,
            shadowColor: Colors.green,
            shape: const RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.green, style: BorderStyle.solid, width: 2.0),
            ),
          ),
        ));
  }

  Widget container(text, String text1) {
    return Container(
        padding: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(border: Border.all(color: Colors.white)),
        child: Row(children: [
          _customers.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: _customers.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: Text(_customers[index]["Name"]),
                          title: Text(_customers[index]["Address"]),
                          subtitle: Text(_customers[index]["Account Number"]),
                        ),
                      );
                    },
                  ),
                )
              : Container(),
          // ? Text(
          //     _customers[text],
          //     style: const TextStyle(fontWeight: FontWeight.bold),
          //   )
          // : Container(),
          // Text(
          // text1,
          // style: const TextStyle(fontWeight: FontWeight.normal),
          // ),
        ]));
  }

  Widget dropDown() {
    return DropdownButton<String>(
      value: dropdownValue,
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['Select Status', 'Delivered', 'Not Delivered']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
