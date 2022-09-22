import 'package:flutter/material.dart';
import 'package:kecs/meter/status.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _isLoading = false;

  String meterno = '';
  String meternumber = "";
  int accnum = 0;
  String name = '';
  String address = "";
  String feeder33 = "";
  String feeder11 = "";
  String regional = '';
  bool isMD = false;
  String llastdate = '';
  String llastamount = '';
  String dropdownValue = 'Select Status';

  Future getMeterInfo() async {
    setState(() {
      _isLoading = true;
    });

    Uri url = Uri.parse(
        'https://kadunaelectric.com/meterreading/kecs/search.php?uid=$meterno');

    var data = {
      'meterno': meterno,
    };

    var response = await http.post(
      url,
      body: json.encode(data),
    );

    final jsondata = json.decode(response.body);

    if (jsondata != "Invalid Meter Number") {
      final jsondata = json.decode(response.body);
      debugPrint(response.body);

      String name = jsondata['customerName'];
      String address = jsondata['customerAddress'];
      String accno = jsondata['customerAccountNo'];
      String meternumber = jsondata['meterNumber'];
      String feeder33 = jsondata['feeder33kV'];
      String feeder11 = jsondata['feeder11KV'];
      String regional = jsondata['regionalOffice'];
      bool isMD = jsondata['isMD'];

      int myInt = int.parse(accno);

      setState(() {
        accnum = myInt;
      });

      SharedPreferences prefMeter = await SharedPreferences.getInstance();
      await prefMeter.setString('name', name);
      await prefMeter.setString('address', address);
      await prefMeter.setInt('accnum', accnum);
      await prefMeter.setString('meterno', meternumber);
      await prefMeter.setString('feeder33', feeder33);
      await prefMeter.setString('feeder11', feeder11);
      await prefMeter.setString('regional', regional);
      await prefMeter.setBool('isMD', isMD);

      getCredppm();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                Text(jsondata, style: const TextStyle(color: Colors.black54)),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    getLastPayment();

    setState(() {
      _isLoading = false;
    });
  }

  Future getLastPayment() async {
    Uri url = Uri.parse(
        'https://kadunaelectric.com/meterreading/kecs/searchpaymentresult.php?AccountNumber=$accnum');

    var response = await http.post(
      url,
      body: json.encode(accnum),
    );

    var jsondata = json.decode(response.body);

    if (jsondata != "Invalid Meter Number") {
      final jsondata = json.decode(response.body);
      debugPrint(response.body);
      String lastdate = jsondata['lastdate'];
      String lastamount = jsondata['lastamount'];

      // debugPrint(lastdate + lastamount);
      setState(() {
        llastdate = lastdate;
        llastamount = lastamount;
      });

      // print(llastdate + llastamount);
      SharedPreferences prefMeter = await SharedPreferences.getInstance();
      await prefMeter.setString('lastdate', llastdate);
      await prefMeter.setString('lastamount', llastamount);

      // getCredppm();
    }
  }

  void getCredppm() async {
    SharedPreferences prefMeter = await SharedPreferences.getInstance();
    setState(() {
      name = prefMeter.getString("name")!;
      address = prefMeter.getString("address")!;
      accnum = prefMeter.getInt("accnum")!;
      meternumber = prefMeter.getString("meterno")!;
      feeder33 = prefMeter.getString("feeder33")!;
      feeder11 = prefMeter.getString("feeder11")!;
      regional = prefMeter.getString("regional")!;
      isMD = prefMeter.getBool("isMD")!;
      llastdate = prefMeter.getString("lastdate")!;
      llastamount = prefMeter.getString("lastamount")!;
    });
  }

  // void getCredppmm() async {
  //   SharedPreferences prefMeter = await SharedPreferences.getInstance();
  //   setState(() {
  //     lastdate = pref.getString("lastdate")!;
  //     lastamount = pref.getString("lastamount")!;
  //   });
  // }

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
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(500, 50),
                          maximumSize: const Size(500, 50),
                        ),
                        onPressed: llastamount == ""
                            ? null
                            : () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const StatusScreen()));
                              },
                        child: const Text('Continue')),
                  ),
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
                  key: key,
                  child: TextFormField(
                    onSaved: (value) => meterno = value.toString(),
                    onChanged: (value) {
                      if (value.isNotEmpty) {}
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please enter your meter number";
                      }
                      return null;
                    },
                    // controller: _inputController,
                    keyboardType: TextInputType.text,
                    decoration: decorate('Meter Number'),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(3.0)),
                ElevatedButton.icon(
                  icon: _isLoading
                      ? const SizedBox(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                          height: 15.0,
                          width: 15.0,
                        )
                      : const Text(''),
                  label: Text(
                    _isLoading ? '' : 'Search Meter Number',
                    style: const TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    if (key.currentState!.validate()) {
                      key.currentState!.save();
                      _isLoading ? null : getMeterInfo();
                      // if (_isLoading == true) {
                      //   getMeterInfo();
                      //   getLastPayment();
                      // }

                      // getCred();

                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(500, 50),
                    maximumSize: const Size(500, 50),
                  ),
                  // child: const Text(
                  //   'Search',
                  //   style:
                  //       TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  // ),
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
                Wrap(
                  textDirection: TextDirection.ltr,
                  verticalDirection: VerticalDirection.down,
                  direction: Axis.vertical,
                  alignment: WrapAlignment.start,
                  children: [
                    container('Name: ', name),
                    container('Address: ', address),
                    container('Meter Number:', meternumber),
                    container3('Account Number:', accnum),
                    container('feeder 33KV:', feeder33),
                    container('feeder 11KV:', feeder11),
                    container('Regional Office:', regional),
                    container2('isMD:', isMD),
                    container('Last Vending Date:', llastdate),
                    container('Last Amount Vended:', llastamount),
                    // dropDown(),
                  ],
                ),
                const Padding(padding: EdgeInsets.all(5.0)),
                const Padding(padding: EdgeInsets.all(5.0)),
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

  Widget container2(text, bool text1) {
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
            '$text1',
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Widget container3(text, int text1) {
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
            text1.toString(),
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
      items: <String>[
        'Select Status',
        'Ok',
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
