import 'package:flutter/material.dart';

class Report extends StatelessWidget {
  const Report({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
      ),
      body: const ReportScreen(),
    );
  }
}

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final key = GlobalKey<FormState>();

  DateTimeRange? _selectedDateRange;

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
      // debugPrint(result.start.toString());
      setState(() {
        _selectedDateRange = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Scaffold(
          body: _selectedDateRange == null
              ? const Center(
                  child: Text('Press the button to show the picker'),
                )
              : Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Start date
                      Text(
                        "Start date: ${_selectedDateRange?.start.toString().split(' ')[0]}",
                        style:
                            const TextStyle(fontSize: 24, color: Colors.blue),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // End date
                      Text(
                          "End date: ${_selectedDateRange?.end.toString().split(' ')[0]}",
                          style:
                              const TextStyle(fontSize: 24, color: Colors.red))
                    ],
                  ),
                ),
          // This button is used to show the date range picker
          floatingActionButton: FloatingActionButton(
            onPressed: _show,
            child: const Icon(Icons.date_range),
          ),
        )
      ],
    );
  }
}
