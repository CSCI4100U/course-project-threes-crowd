import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:events_service/EventForm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventView extends StatefulWidget {
  EventView({
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
  DateTimeRange? date;

  Future retrieveData() async {
    DocumentSnapshot data = await widget.ref.get();
    // title = data.get("title");
    Map<String, dynamic> fields = data.data() as Map<String, dynamic>;

    location = fields["location"];
    description = fields["description"];
    DateTime start = DateTime.parse(fields['start']);
    DateTime end = DateTime.parse(fields['end']);
    date = DateTimeRange(
      start: start,
      end: end,
    );

    return;
  }

  void onEdit(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => EventForm(
              ref: widget.ref,
            )));
    await retrieveData();
    setState(() {});
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
            // if (!snapshot.hasData) return const Text("Loading...");

            return Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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

                  // TODO: put an interactive map to the location here?

                  Text(
                    AppLocalizations.of(context)!.what,
                    style: widget.labelStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 12),
                    child: Text(description ?? ""),
                  ),
                ],
              ),
            );
          }),
        ));
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
