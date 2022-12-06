import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_service/EventMap.dart';
import 'package:events_service/LoadingSpinner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:events_service/EventForm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class EventView extends StatefulWidget {
  const EventView({
    super.key,
    required this.title,
    required this.ref,
  });

  final String title;
  final DocumentReference ref;

  final TextStyle labelStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  String? location;
  String? description;
  int? attendence;
  int? attendenceCap;
  DateTimeRange? date;
  LatLng? send_loc;
  Position? current_loc;

  Future<void> retrieveData() async {
    DocumentSnapshot data = await widget.ref.get();
    // title = data.get("title");
    Map<String, dynamic> fields = data.data() as Map<String, dynamic>;

    // check widget is in tree
    if (!mounted) return;

    setState(() {
      location = fields["location"];
      description = fields["description"];
      attendence = fields["attendence"];
      attendenceCap = fields["attendenceCap"];
      DateTime start = DateTime.parse(fields['start']);
      DateTime end = DateTime.parse(fields['end']);
      date = DateTimeRange(
        start: start,
        end: end,
      );
    });
  }

  Future<void> geocode(String address) async {
    try{
      final List<Location> locations = await locationFromAddress(address);
        if(locations[0] != null){
        current_loc = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
        send_loc = LatLng(locations[0].latitude, locations[0].longitude);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EventMap(
                  loc: send_loc,
                  current_loc: current_loc,
                )));
      }
    }catch(e){
      SnackBar snackBar = SnackBar(
        content: Text('Please set a workable address'),
      );
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    
    
    /*
    current_loc = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    send_loc = LatLng(locations[0].latitude, locations[0].longitude);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EventMap(
              loc: send_loc,
              current_loc: current_loc,
            )));*/
  }

  Future<void> onEdit(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => EventForm(
                  ref: widget.ref,
                )));
    await retrieveData();
  }

  Widget buildAttendanceGraph(BuildContext context) {
    return charts.BarChart(
      [
        charts.Series<int, String>(
          id: AppLocalizations.of(context)!.attendence,
          domainFn: (datum, index) => AppLocalizations.of(context)!.attendence,
          measureFn: (datum, index) => datum,
          data: [attendence ?? 0],
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          fillColorFn: (_, __) =>
              charts.MaterialPalette.blue.shadeDefault.lighter,
        ),
        charts.Series<int, String>(
          id: AppLocalizations.of(context)!.attendenceCap,
          domainFn: (datum, index) =>
              AppLocalizations.of(context)!.attendenceCap,
          measureFn: (datum, index) => datum,
          data: [attendenceCap ?? 0],
          colorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault,
          fillColorFn: (_, __) =>
              charts.MaterialPalette.gray.shadeDefault.lighter,
        ),
      ],
      animate: false,
      vertical: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            onPressed: () => onEdit(context),
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: FutureBuilder(
        future: retrieveData(),
        builder: ((context, snapshot) {
          // if (!snapshot.hasData) return const LoadingSpinner();

          return LayoutBuilder(
            builder: (context, constraints) => Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              padding: const EdgeInsets.all(4),
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: constraints.maxWidth / 4,
                    height: constraints.maxHeight / 4,
                    child: buildAttendanceGraph(context),
                  ),
                  Text(
                    AppLocalizations.of(context)!.when,
                    style: widget.labelStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 12),
                    child: Text(
                      //date?.toString() ?? "",
                      "${prettifyDate(date?.start)} - ${prettifyDate(date?.end)}",
                    ),
                    // TODO: pretty date, calendar?
                  ),
                  Text(
                    AppLocalizations.of(context)!.where,
                    style: widget.labelStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 12),
                    child: Text(location ?? ""),
                  ),
                  Text(
                    AppLocalizations.of(context)!.what,
                    style: widget.labelStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 12),
                    child: Text(description ?? ""),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      geocode(location ?? '');
                    },
                    child: const Icon(Icons.map),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

String prettifyDate(DateTime? input, {bool isShort = true}) {
  // Returns a string representation of a date in the format
  // "Weekday, Month Day, Year, 12HTime [AM/PM] [UTC]"
  //
  // isShort controls whether the shortened versions of month and weekday names should be used (three characters)
  String out = "";

  if (input == null) {
    return "Unknown";
  }

  List<String> weekdays =
      DateFormat.EEEE(Platform.localeName).dateSymbols.STANDALONEWEEKDAYS;
  String dayName = isShort
      ? weekdays[input.weekday - 1].substring(0, 3)
      : weekdays[input.weekday - 1];

  List<String> months =
      DateFormat.MMMM(Platform.localeName).dateSymbols.STANDALONEMONTHS;
  String month = isShort
      ? months[input.month - 1].substring(0, 3)
      : months[input.month - 1];

  String ampm = (input.hour < 12) ? "AM" : "PM";
  String utc = input.isUtc ? "UTC" : "";

  out =
      "$dayName, $month ${input.day}, ${input.year}, ${(input.hour % 12 == 0) ? 12 : input.hour}:${(input.minute / 10).floor() % 10}${input.minute % 10 // Formatting the minute digits (eg for things like XX:06)
      } $ampm $utc";

  return out;
}
