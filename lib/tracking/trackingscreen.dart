import 'package:flutter/material.dart';
import 'package:kecs/tracking/paid.dart';
import 'package:kecs/tracking/unpaid.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final key = GlobalKey<FormState>();
  // final _controller = TextEditingController();

  // void clearText() {
  //   _controller.clear();
  // }
  final TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  String dropdownValue = 'Select Status';

  bool _visible = false;

  void _toggle() {
    setState(() {
      _visible = !_visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      Material(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              AppBar(
                title: const Text('Tracking'),
              ),
              Wrap(
                children: [
                  // const Padding(padding: EdgeInsets.all(20.0)),
                  card(),
                  card1(),
                  card2(),
                  const Padding(padding: EdgeInsets.all(5.0)),
                  ElevatedButton(
                      onPressed: () {
                        if (dropdownValue == 'Paid') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Paid()));
                        } else if (dropdownValue == 'Unpaid') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Unpaid()));
                          // } else if (dropdownValue == 'Disconnected') {
                          //   // _controller.clear();
                          //   setState(() {
                          //     // dropdownValue = <String;
                          //   });
                        }
                      },
                      child: const Text('Continue'))
                ],
              )
            ],
          ))
    ]);
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
                            }
                          : null,
                      child: const Text(
                        'Search',
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
                    container('Name:'),
                    container('Address:'),
                    container('Account Number:'),
                    container('Meter Number:'),
                    container('Last Payment Date:'),
                    container('Total Payment:'),
                    container('Total Billed Amount:'),
                    container('Closing Balance:'),
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
                    container('Last Vending:'),
                    container('Last Vending Date:'),
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

  Widget container(String text) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget dropDown() {
    return DropdownButton<String>(
      value: dropdownValue,
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>[
        'Select Status',
        'Paid',
        'Unpaid',
      ].map<DropdownMenuItem<String>>((String value) {
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
