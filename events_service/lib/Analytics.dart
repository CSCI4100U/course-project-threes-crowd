import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'EventModel.dart';

class Analytics extends StatefulWidget {
  Analytics({super.key});

  List<Map> records = [];

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  Future<void> retrieveData() async {
    EventModel db = EventModel();
    List<Map> temp_records = await db.getEventsList();

    setState(() {
      widget.records = temp_records;
    });
  }

  Widget buildGraph(BuildContext context) {
    Map<String, int> event_freq = {};

    widget.records.forEach((el) {
      String event = el["title"];
      event_freq[event] = el["attendence"];
    });

    return charts.BarChart(
      [
        charts.Series<MapEntry<String, int>, String>(
          id: "Event Attendance",
          domainFn: (datum, index) => datum.key,
          measureFn: (datum, index) => datum.value,
          data: event_freq.entries.toList(),
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          fillColorFn: (_, __) =>
              charts.MaterialPalette.blue.shadeDefault.lighter,
        ),
      ],
      animate: false,
      vertical: false,
    );
  }

  Widget buildDataTable(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(
          label: Expanded(
            child: Text(
              AppLocalizations.of(context)!.eventSaved1,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              AppLocalizations.of(context)!.attendence,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ],
      rows: widget.records
          .map((el) => DataRow(cells: [
                DataCell(Text(el["title"])),
                DataCell(Text(el["attendence"].toString())),
              ]))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: FutureBuilder(
            future: retrieveData(),
            builder: (context, snapshot) => ListView(
              children: [
                Container(
                  height: constraints.maxHeight / 2,
                  child: buildGraph(context),
                ),
                buildDataTable(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
