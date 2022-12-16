import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ReportScreen1 extends StatefulWidget {
  final String id;
  const ReportScreen1({Key? key, required this.id}) : super(key: key);

  @override
  State<ReportScreen1> createState() => _ReportScreen1State();
}

class _ReportScreen1State extends State<ReportScreen1> {
  final key = GlobalKey<FormState>();

  DateTimeRange? _selectedDateRange;

  bool _isLoading = false;

  String delivered = '';
  String notDelivered = '';
  String total = '';

  void _show() async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2022, 1, 1),
      lastDate: DateTime(2030, 12, 31),
      currentDate: DateTime.now(),
      saveText: 'Done',
    );

    if (result != null) {
      // Rebuild the UI
      setState(() {
        _selectedDateRange = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Page'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(19.0),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Click on the floating button to select date range',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    )),
                DataTable(
                  columns: const [
                    DataColumn(
                        label: Text('Summary',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Activity',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                  ],
                  rows: [
                    DataRow(cells: [
                      const DataCell(Text('Bills Delivered')),
                      DataCell(Text(delivered)),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Bills UnDelivered')),
                      DataCell(Text(notDelivered)),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Total')),
                      DataCell(Text(total)),
                    ]),
                  ],
                ),
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
                      _isLoading ? '' : 'Request Summary',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(500, 50),
                      maximumSize: const Size(500, 50),
                    ),
                    onPressed: _selectedDateRange == null
                        ? null
                        : () => fetchResult()),
              ]),
        ),
      ),

      // This button is used to show the date range picker
      floatingActionButton: FloatingActionButton(
        onPressed: _show,
        child: const Icon(Icons.date_range),
      ),
    );
  }

  Future fetchResult() async {
    setState(() {
      _isLoading = true;
    });

    Uri url =
        Uri.parse('https://kadunaelectric.com/meterreading/kecs/report.php');

    try {
      var data = {
        'ID': widget.id,
        'start': '${_selectedDateRange?.start.toString().split(' ')[0]}'
            ' '
            '00:00:00',
        'end': '${_selectedDateRange?.end.toString().split(' ')[0]}'
            ' '
            '23:00:00',
      };

      var response = await http.post(
        url,
        body: json.encode(data),
      );
      var jsondata = json.decode(response.body);

      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        int deliveredJson = jsondata["Delivered"];
        int notDeliveredJson = jsondata["NotDelivered"];
        int totalJson = jsondata["Total"];

        setState(() {
          delivered = deliveredJson.toString();
          notDelivered = notDeliveredJson.toString();
          total = totalJson.toString();
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(jsondata, style: const TextStyle(color: Colors.red)),
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
    } catch (e) {
      //debugPrint('error');
      setState(() {
        _isLoading = false;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }
}
