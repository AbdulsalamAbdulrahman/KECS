import 'package:flutter/material.dart';
import 'package:kecs/bill/delivered.dart';
import 'package:kecs/bill/notdelivered.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  final key = GlobalKey<FormState>();

  String dropdownValue = 'Select Status';
  @override
  Widget build(BuildContext context) {
    return Material(
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
                ElevatedButton(
                    onPressed: () {
                      if (dropdownValue == 'Delivered') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DeliveredScreen(
                                      title: '',
                                    )));
                      } else if (dropdownValue == 'Not Delivered') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NotDeliveredScreen(
                                      title: '',
                                    )));
                      }
                    },
                    child: const Text('Continue'))
              ],
            )
          ],
        ));
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
                    keyboardType: TextInputType.text,
                    decoration: decorate('Account Number'),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(3.0)),
                ElevatedButton(
                  onPressed: () {},
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
                const Text('Customer Billing Information',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                container('Name:'),
                container('Address:'),
                container('Account Number:'),
                container('Meter Number:'),
                container('Last Payment Date:'),
                container('Total Payment:'),
                container('Total Billed Amount:'),
                container('Closing Balance:'),
                container('Latitude:'),
                container('Longitude:'),
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
    );
  }

  Widget card2() {
    return SizedBox(
      width: 500,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Payment Details',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
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

  // DecoratedBox borderBox() {
  //   return DecoratedBox(
  //       decoration: BoxDecoration(
  //     color: Colors.green,
  //     border: Border.all(
  //       color: Colors.white,
  //       width: 8,
  //     ),
  //     ,
  //   ));
  // }
}
