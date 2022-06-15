import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';

class Paid extends StatelessWidget {
  const Paid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Paid'),
      ),
      body: const PaidScreen(),
    );
  }
}

class PaidScreen extends StatefulWidget {
  const PaidScreen({Key? key}) : super(key: key);

  @override
  State<PaidScreen> createState() => _PaidScreenState();
}

class _PaidScreenState extends State<PaidScreen> {
  final key = GlobalKey<FormState>();

  String dropdownValue = 'Select Recipient';

  String _satisfied = "Yes";
  String _experience = "Good";
  String _service = "Good";

  final List<String> _status = ["Yes", "No"];
  final List<String> _status1 = ["Good", "Bad"];
  final List<String> _status2 = ["Good", "Poor"];

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
                    container1('Customer Experience'),
                    container2('Customer Service'),
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
        RadioGroup<String>.builder(
          direction: Axis.horizontal,
          groupValue: _satisfied,
          horizontalAlignment: MainAxisAlignment.spaceAround,
          onChanged: (value) => setState(() {
            _satisfied = value!;
          }),
          items: _status,
          textStyle: const TextStyle(fontSize: 15),
          itemBuilder: (item) => RadioButtonBuilder(
            item,
          ),
        ),
      ],
    );
  }

  Widget container1(String text) {
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
        RadioGroup<String>.builder(
          direction: Axis.horizontal,
          groupValue: _experience,
          horizontalAlignment: MainAxisAlignment.spaceAround,
          onChanged: (value) => setState(() {
            _experience = value!;
          }),
          items: _status1,
          textStyle: const TextStyle(fontSize: 15),
          itemBuilder: (item) => RadioButtonBuilder(
            item,
          ),
        ),
      ],
    );
  }

  Widget container2(String text) {
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
        RadioGroup<String>.builder(
          direction: Axis.horizontal,
          groupValue: _service,
          horizontalAlignment: MainAxisAlignment.spaceAround,
          onChanged: (value) => setState(() {
            _service = value!;
          }),
          items: _status2,
          textStyle: const TextStyle(fontSize: 15),
          itemBuilder: (item) => RadioButtonBuilder(
            item,
          ),
        ),
      ],
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
