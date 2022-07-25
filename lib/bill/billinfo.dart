import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BillInfo extends StatefulWidget {
  const BillInfo({Key? key}) : super(key: key);

  @override
  State<BillInfo> createState() => _BillInfoState();
}

class _BillInfoState extends State<BillInfo> {
  String name = '';

  final key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getCred();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      name = pref.getString("name")!;
    });
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
                    // listView()
                    // const Padding(padding: EdgeInsets.all(20.0)),
                    // card(),
                    card1(),
                    // card2(),
                    // const Padding(padding: EdgeInsets.all(5.0)),
                    // ElevatedButton(
                    //     onPressed: () {
                    //       if (dropdownValue == 'Delivered') {
                    //         Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) =>
                    //                     const DeliveredScreen()));
                    //       } else if (dropdownValue == 'Not Delivered') {
                    //         Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) =>
                    //                     const NotDeliveredScreen()));
                    //       }
                    //     },
                    //     child: const Text('Continue'))
                  ],
                )
              ],
            ))
      ],
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
                container('Name', name),
                container('Address: ', ''),
                container('Account Number:', ''),
                container('Meter Number:', ''),
                container('Last Payment Date:', ''),
                container('Total Payment:', ''),
                container('Total Billed Amount:', ''),
                container('Closing Balance:', ''),
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

  Widget container(text, String text1) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            text1,
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
