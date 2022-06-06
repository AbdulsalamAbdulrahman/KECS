import 'package:flutter/material.dart';
import 'package:kecs/meterreading/status.dart';
import 'package:kecs/meterreading/updatescreen.dart';

class MeterScreen extends StatefulWidget {
  const MeterScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MeterScreen> createState() => _MeterScreenState();
}

class _MeterScreenState extends State<MeterScreen> {
  final key = GlobalKey<FormState>();

  chooseImage() {}
  startUpload() {}

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
                  title: const Text('Meter Reading'),
                ),
                Wrap(
                  children: [
                    // const Padding(padding: EdgeInsets.all(20.0)),
                    card(),
                    card1(),

                    card3(),
                    const Padding(padding: EdgeInsets.all(10.0)),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const StatusScreen(
                                        title: '',
                                      )));
                        },
                        child: const Text('Continue')),
                    const Padding(padding: EdgeInsets.all(10)),

                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UpdateScreen(
                                        title: '',
                                      )));
                        },
                        child: const Text('Update'))
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
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Padding(padding: EdgeInsets.all(5.0)),
                Form(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: decorate('Account Number'),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(3.0)),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Submit',
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
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
    return SizedBox(
      width: 500,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Customer Meter Information',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                container('Name:'),
                container('Address:'),
                container('Phone No'),
                container('Account No:'),
                container('Meter No:'),
                container('Tariff Code:'),
                container('Latitude:'),
                container('Longitude:'),
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

  Widget card3() {
    return SizedBox(
      width: 500,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Upload Image',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Padding(padding: EdgeInsets.only(top: 10)),
                OutlinedButton(
                  onPressed: chooseImage,
                  child: const Text("Choose image"),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                OutlinedButton(
                  onPressed: startUpload,
                  child: const Text("Upload Image"),
                ),
                const SizedBox(
                  height: 20.0,
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

  Widget container1(String text) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
  // Widget card1() {
  //   return Material(

  //     decoration: BoxDecoration(border: Border.all(color: Colors.white)),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: const <Widget>[
  //         Text('Meter'),
  //         Text('Meter'),
  //         Text('Meter'),
  //         Text('Meter')
  //       ],
  //     ),
  //   );
  // }

  // Widget card1() {
  //   return SizedBox(
  //     height: 25,
  //     width: 500,
  //     child: Card(
  //       child: Column(
  //         children: [Text('Meter Information')],
  //       ),
  // // margin: const EdgeInsets.all(50.0),
  // child: Padding(
  //   padding: const EdgeInsets.all(10.0),
  //   child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         const Text('Meter Information'),
  //         Container(
  //           // margin: const EdgeInsets.all(15.0),
  //           // padding: const EdgeInsets.all(3.0),
  //           decoration:
  //               BoxDecoration(border: Border.all(color: Colors.black)),
  //           child: const Text('Meter No:'),
  //         )
  //       ]),
  // ),
  //     ),
  //   );
  // }

  InputDecoration decorate(String label) {
    return InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(),
        ));
  }
  // DecoratedBox borderBox() {
  //   return DecoratedBox(
  //       decoration: BoxDecoration(
  //     color: Colors.green,
  //     border: Border.all(
  //       color: Colors.white,
  //       width: 8,
  //     ),
  //     borderRadius: BorderRadius.circular(15.0),
  //   ));
  // }
}
