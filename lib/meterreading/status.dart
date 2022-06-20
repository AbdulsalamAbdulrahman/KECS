import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';

class Status extends StatelessWidget {
  const Status({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: StatusScreen(),
    );
  }
}

class StatusScreen extends StatefulWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final key = GlobalKey<FormState>();

  String dropdownValue = 'Select Remark';

  String _seal = "Yes";
  final List<String> _status = ["Yes", "No"];

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            AppBar(
              title: const Text('Meter Reading'),
            ),
            Wrap(
              children: [
                card(),
              ],
            )
          ],
        ));
  }

  Widget card() {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(padding: EdgeInsets.all(8)),
              container('Seal Broken'),
              const Padding(padding: EdgeInsets.all(8)),
              OutlinedButton(
                onPressed: () {},
                child: const Text("Upload Image"),
              ),
              const Padding(padding: EdgeInsets.all(8)),
              Form(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  textField('Kilowatt Hour Readings', 1),
                  const Padding(padding: EdgeInsets.all(8)),
                  textField('MDI', 1),
                  const Padding(padding: EdgeInsets.all(8)),
                  dropDown(),
                  const Padding(padding: EdgeInsets.all(8)),
                  textField('Comment', 8),
                  const Padding(padding: EdgeInsets.all(8)),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(500, 50),
                      maximumSize: const Size(500, 50),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )),
            ]),
      ),
    );
  }

  Widget textField(String text, int n) {
    return TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: text,
      ),
      maxLines: n,
    );
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
          groupValue: _seal,
          horizontalAlignment: MainAxisAlignment.spaceAround,
          onChanged: (value) => setState(() {
            _seal = value!;
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
        'Select Remark',
        'Meter Faulty',
        'Meter Mismatch',
        'Ok',
        'Disconnected',
        'Meter by pass',
        'Meter Tempered',
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
