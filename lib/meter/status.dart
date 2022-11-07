import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class StatusScreen extends StatefulWidget {
  final String meternumber;
  final int accnum;
  final String name;
  final String address;
  final String feeder33;
  final String feeder11;
  final String regional;
  final bool isMD;
  final String llastdate;
  final String llastamount;
  final String geolat;
  final String geolong;
  final String id;

  const StatusScreen({
    Key? key,
    required this.meternumber,
    required this.accnum,
    required this.name,
    required this.address,
    required this.feeder33,
    required this.feeder11,
    required this.regional,
    required this.isMD,
    required this.llastdate,
    required this.llastamount,
    required this.geolat,
    required this.geolong,
    required this.id,
  }) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final key = GlobalKey<FormState>();

  TextEditingController kwh = TextEditingController();
  TextEditingController mdi = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController commentM = TextEditingController();

  String phpurl =
      'https://kadunaelectric.com/meterreading/kecs/write_meter_reading.php';

  String dropdownValue = 'Select Remark';

  String dropdownValueSeal = 'Seal Status';

  bool _isLoading = false;
  late bool error, sending, success;
  late String msg;

  String _seal = "Yes";
  final List<String> _status = ["Yes", "No"];

  @override
  void initState() {
    super.initState();
  }

  Future sendData() async {
    setState(() {
      _isLoading = true;
    });

    var res = await http.post(Uri.parse(phpurl), body: {
      "fullname": widget.name,
      "isMD": widget.isMD.toString(),
      "kwh": kwh.text,
      "mdi": mdi.text,
      "phone": phone.text,
      "meternumber": widget.meternumber,
      "accnum": widget.accnum.toString(),
      "readStatus": dropdownValue,
      "readerRemark": commentM.text,
      "sealStatus": dropdownValueSeal,
      "id": widget.id,
      "lat": widget.geolat,
      "long": widget.geolong
    }); //sending post request with header data

    if (res.statusCode == 200) {
      var data = json.decode(res.body); //decoding json to array
      if (data["error"]) {
        setState(() {
          //refresh the UI when error is recieved from server
          sending = false;
          error = true;
          msg = data["message"]; //error message from server
        });
      } else {
        showMessage('Data Submitted Succesfully');
        //after write success, make fields empty

        setState(() {
          sending = false;
          success = true; //mark success and refresh UI with setState
        });
      }
    } else {
      //there is error
      setState(() {
        error = true;
        msg = "Error during sending data.";
        sending = false;
        //mark error and refresh UI with setState
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meter Reading')),
      body: ListView(scrollDirection: Axis.vertical, children: <Widget>[
        Material(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Wrap(
                  children: <Widget>[
                    card(),
                  ],
                )
              ],
            ))
      ]),
    );
  }

  Widget card() {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(padding: EdgeInsets.all(8)),
              OutlinedButton(
                onPressed: () {},
                child: const Text("Upload Image"),
              ),
              const Padding(padding: EdgeInsets.all(8)),
              Form(
                  key: key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      textField('Kilowatt Hour Readings', 1, kwh),
                      const Padding(padding: EdgeInsets.all(8)),
                      textField('MDI', 1, mdi),
                      const Padding(padding: EdgeInsets.all(8)),
                      textField('Phone Number', 1, phone),
                      const Padding(padding: EdgeInsets.all(8)),
                      dropDown(),
                      const Padding(padding: EdgeInsets.all(8)),
                      dropDownSeal(),
                      const Padding(padding: EdgeInsets.all(8)),
                      textFieldC('Comment', 8, commentM),
                      const Padding(padding: EdgeInsets.all(8)),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(500, 50),
                            maximumSize: const Size(500, 50),
                          ),
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
                            _isLoading ? '' : 'Submit',
                            style: const TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            if (key.currentState!.validate()) {
                              _isLoading ? null : sendData();
                            }
                          }),
                    ],
                  )),
            ]),
      ),
    );
  }

  Widget textField(String text, int n, controllerV) {
    return TextFormField(
      controller: controllerV,
      validator: validateField,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: text,
      ),
      maxLines: n,
    );
  }

  Widget textFieldC(String text, int n, controllerV) {
    return TextFormField(
      controller: controllerV,
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
      validator: validateD,
      decoration: decorate(''),
      value: dropdownValue,
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>[
        'Select Remark',
        'Ok',
        'Meter Faulty',
        'Meter Mismatch',
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

  Widget dropDownSeal() {
    return DropdownButtonFormField<String>(
      validator: validateDS,
      decoration: decorate(''),
      value: dropdownValueSeal,
      onChanged: (String? newValue) {
        setState(() {
          dropdownValueSeal = newValue!;
        });
      },
      items: <String>[
        'Seal Status',
        'Broken',
        'Not Broken',
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

  Future<dynamic> showMessage(String msg) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(msg),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String? validateField(value) {
    if (value.isEmpty) {
      return "field is required";
    }
    return null;
  }

  String? validateDS(value) {
    if (value == 'Select Status') {
      return "field is required";
    }
    return null;
  }

  String? validateD(value) {
    if (value == 'Select Remark') {
      return "field is required";
    }
    return null;
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
