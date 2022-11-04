import 'package:flutter/material.dart';

class EventView extends StatelessWidget {
  EventView({
    super.key,
    required String this.title,
    required String this.location,
  });

  final String title;
  final String location;
  final String description = "NYI";
  final DateTimeRange date =
      DateTimeRange(start: DateTime(2022), end: DateTime(2023));

  final TextStyle labelStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  "What? ",
                  style: labelStyle,
                ),
                Text(description),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  "When? ",
                  style: labelStyle,
                ),
                Text(date.toString()), // TODO: pretty date, calender?
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  "Where? ",
                  style: labelStyle,
                ),
                Text(location),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
