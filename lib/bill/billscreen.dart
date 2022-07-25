import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kecs/bill/billinfo.dart';
// import 'package:kecs/bill/delivered.dart';
// import 'package:kecs/bill/notdelivered.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({Key? key}) : super(key: key);

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  final key = GlobalKey<FormState>();

  String accno = "";

  String dropdownValue = 'Select Status';

  Future getAccNo() async {
    Uri url = Uri.parse(
        'https://kadunaelectric.com/meterreading/kecs/dotnet_billinghistory.php?id=$accno');

    var data = {
      'accno': accno,
    };
    print(accno);
    var response = await http.post(
      url,
      body: json.encode(data),
    );

    // final jsondata = json.decode(response.body);

    // print(apidata);

    if (response.statusCode == 200) {
      // print(response.body);
      final data = json.decode(response.body);
      print(data[0]['customerName']);

      String name = data[0]['customerName'];

      debugPrint(name);

      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('name', name);

      // SharedPreferences pref = await SharedPreferences.getInstance();
      // pref.setString("name", data[0]['customerName']);

      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => const BillInfo()));
      // String customername = jsondata["customerName"];

      // print(customername);
    } else {
      print('Failed');
    }
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
                    card(),
                    // card1(),
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
                  key: key,
                  child: TextFormField(
                    onSaved: (value) => accno = value.toString(),
                    onChanged: (value) {
                      if (value.isNotEmpty) {}
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please enter your account number";
                      }
                      return null;
                    },
                    // controller: _inputController,
                    keyboardType: TextInputType.text,
                    decoration: decorate('Account Number'),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(3.0)),
                ElevatedButton(
                  onPressed: () async {
                    if (key.currentState!.validate()) {
                      key.currentState!.save();
                      getAccNo();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BillInfo()));
                      // getCred();
                    }
                  },
                  child: const Text(
                    'Search',
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                )
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
                container('Name', ''),
                container('Address: ', ''),
                container('Account Number:', ''),
                container('Meter Number:', ''),
                container('Last Payment Date:', ''),
                container('Total Payment:', ''),
                container('Total Billed Amount:', ''),
                container('Closing Balance:', ''),
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
