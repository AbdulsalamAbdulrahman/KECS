import 'package:flutter/material.dart';
import 'package:kecs/meter/status.dart';

class Meter extends StatelessWidget {
  const Meter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meter Reading'),
      ),
      body: const MeterScreen(),
    );
  }
}

class MeterScreen extends StatefulWidget {
  const MeterScreen({Key? key}) : super(key: key);

  @override
  State<MeterScreen> createState() => _MeterScreenState();
}

class _MeterScreenState extends State<MeterScreen> {
  final key = GlobalKey<FormState>();

  bool _visible = false;

  final TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

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
              Wrap(
                children: [
                  // const Padding(padding: EdgeInsets.all(20.0)),
                  card(),
                  card1(),
                  card2(),
                  const Padding(padding: EdgeInsets.all(5.0)),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const StatusScreen()));
                      },
                      child: const Text('Submit'))
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
                    container('Address: '),
                    container('Account Number:'),
                    container('Meter Number:'),
                    container('Last Payment Date:'),
                    container('Total Payment:'),
                    container('Notice Number:'),
                    container('Closing Balance:'),
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
                    const Text('Last Reading',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    container('Date:'),
                    container('Tinme:'),
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

  InputDecoration decorate(String label) {
    return InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(),
        ));
  }
}
