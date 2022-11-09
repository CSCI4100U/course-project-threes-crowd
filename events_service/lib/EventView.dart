import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventView extends StatelessWidget {
  EventView({
    super.key,
    required String this.title,
    required DocumentReference<Object?> this.ref,
  });

  final String title;
  final DocumentReference ref;
  String? location;
  String? description;
  DateTimeRange? date;

  final TextStyle labelStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  Future retrieveData() async {
    DocumentSnapshot data = await ref.get();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: FutureBuilder(
          future: retrieveData(),
          builder: ((context, snapshot) {
            // if (!snapshot.hasData) return const Text("Loading...");

            return Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "What? ",
                      style: labelStyle,
                    ),
                    Text(description ?? ""),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "When? ",
                      style: labelStyle,
                    ),
                    Text(
                        date?.toString() ?? ""), // TODO: pretty date, calender?
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "Where? ",
                      style: labelStyle,
                    ),
                    Text(location ?? ""),
                  ],
                ),
              ],
            );
          }),
        ));
  }
}
