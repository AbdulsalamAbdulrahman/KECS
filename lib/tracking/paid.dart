import 'package:flutter/material.dart';

class Paid extends StatelessWidget {
  static String routeName = "/Paid";

  const Paid({Key? key, required String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Paid'),
      ),
      body: const PaidScreen(title: ''),
    );
  }
}

// enum CustomerS { yes, no }
// enum CustomerExperience { good, bad }
// enum CustomerService { good, poor }

class PaidScreen extends StatefulWidget {
  const PaidScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<PaidScreen> createState() => _PaidScreenState();
}

class _PaidScreenState extends State<PaidScreen> {
  final key = GlobalKey<FormState>();
  String dropdownValue = 'Select Recipient';
  // CustomerS _satisfied = CustomerS.yes;
  // CustomerExperience _experience = CustomerExperience.good;
  // CustomerService _service = CustomerService.good;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Bill Paid'),
            ),
            const Padding(padding: EdgeInsets.only(top: 5.0)),
            Form(
              key: key,
              child: Padding(
                padding: const EdgeInsets.all(19.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 0.0),
                      child: Center(
                        child: SizedBox(
                          width: 200,
                          height: 100,
                        ),
                      ),
                    ),
                    SizedBox(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          'Upload',
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    // const Padding(padding: EdgeInsets.all(5.0)),
                    container('Customer Satisfied'),
                    container('Customer Experience'),
                    container('Customer Service'),
                    const Padding(padding: EdgeInsets.all(5.0)),
                    ElevatedButton(
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

  Widget container(String text) {
    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(border: Border.all(color: Colors.white)),
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // Widget radio(String text) {
  //   return Row(children: <Widget>[
  //     Radio(
  //       value: BestTutorSite.javatpoint,
  //       groupValue: _site,
  //       onChanged: (BestTutorSite? value) {
  //         setState(() {
  //           _site = value!;
  //         });
  //       },
  //     ),
  //     Radio(
  //       value: BestTutorSite.w3schools,
  //       groupValue: _site,
  //       onChanged: (BestTutorSite? value) {
  //         setState(() {
  //           _site = value!;
  //         });
  //       },
  //     ),
  //   ]);
  // }

  InputDecoration decorate(String label) {
    return InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(),
        ));
  }
}
