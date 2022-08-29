import 'package:flutter/material.dart';
import 'package:kecs/bill/bill.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotDelivered extends StatelessWidget {
  const NotDelivered({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: NotDelivered(),
    );
  }
}

class NotDeliveredScreen extends StatefulWidget {
  final String dropdownValue;
  const NotDeliveredScreen({Key? key, required this.dropdownValue})
      : super(key: key);

  @override
  State<NotDeliveredScreen> createState() => _NotDeliveredScreenState();
}

class _NotDeliveredScreenState extends State<NotDeliveredScreen> {
  final key = GlobalKey<FormState>();
  String dropdownValue = 'Select Reason';

  String name = '';
  String address = "";

  @override
  void initState() {
    super.initState();
    getCred();
  }

  void getCred() async {
    SharedPreferences prefBill = await SharedPreferences.getInstance();
    setState(() {
      name = prefBill.getString("name")!;
      address = prefBill.getString("address")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            AppBar(
              // automaticallyImplyLeading: false,
              title: const Text('Bill Not Delivered'),
            ),
            Padding(
              padding: const EdgeInsets.all(19.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 50.0),
                  ),
                  const Text(
                    'Reason',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  dropDown(),
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
                    onPressed: () async {
                      debugPrint(name + address + widget.dropdownValue);
                      SharedPreferences prefNotDelivered =
                          await SharedPreferences.getInstance();
                      await prefNotDelivered.clear();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Bill()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
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

  InputDecoration decorate(String label) {
    return InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(),
        ));
  }
}
