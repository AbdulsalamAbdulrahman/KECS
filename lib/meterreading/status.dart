import 'package:flutter/material.dart';
import 'package:kecs/meterreading/meterscreen.dart';

class Status extends StatelessWidget {
  static String routeName = "/Status";

  const Status({Key? key, required String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: StatusScreen(title: ''),
    );
  }
}

class StatusScreen extends StatefulWidget {
  const StatusScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final key = GlobalKey<FormState>();

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
                // const Padding(padding: EdgeInsets.all(20.0)),
                card(),
                //     const Padding(padding: EdgeInsets.all(5.0)),
                //     ElevatedButton(
                //         onPressed: () {
                //           Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (context) => const MeterScreen(
                //                         title: '',
                //                       )));
                //         },
                //         child: const Text('Continue')),
                //     const Padding(padding: EdgeInsets.all(5)),
              ],
            )
          ],
        ));
  }

  // Widget card() {
  //   return SizedBox(
  //     child: Card(
  //       child: Padding(
  //         padding: const EdgeInsets.all(10.0),
  //         child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: <Widget>[
  //               const Text('Search Customer',
  //                   style:
  //                       TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
  //               const Padding(padding: EdgeInsets.all(5.0)),
  //               Form(
  //                 child: TextFormField(
  //                   keyboardType: TextInputType.text,
  //                   decoration: decorate('Account Number'),
  //                 ),
  //               ),
  //               const Padding(padding: EdgeInsets.all(3.0)),
  //               ElevatedButton(
  //                 onPressed: () {},
  //                 child: const Text(
  //                   'Submit',
  //                   style:
  //                       TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
  //                 ),
  //               ),
  //             ]),
  //       ),
  //       elevation: 5,
  //       shadowColor: Colors.green,
  //       shape: const RoundedRectangleBorder(
  //         side: BorderSide(
  //             color: Colors.green, style: BorderStyle.solid, width: 2.0),
  //       ),
  //     ),
  //   );
  // }

  Widget card() {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(padding: EdgeInsets.all(8)),
              Form(
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Kilowatt Hour Readings',
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.all(8)),
              Form(
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'MDI',
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.all(8)),
              const Padding(padding: EdgeInsets.all(8)),
              Form(
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Remarks',
                  ),
                  maxLines: 8,
                ),
              ),
              const Padding(padding: EdgeInsets.all(8)),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MeterScreen(
                                title: '',
                              )));
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
              ),
            ]),
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

  InputDecoration decorate(String label) {
    return InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(),
        ));
  }
}
