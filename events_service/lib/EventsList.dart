import 'package:flutter/material.dart';
import 'EventTile.dart';
import 'EventModel.dart';

class EventsList extends StatefulWidget {
  EventsList({super.key});

  List<EventTile> records = [
    const EventTile(title: "CppCon", location: "Vancouver"),
    const EventTile(title: "PyCon", location: "Sanfrancisco"),
  ];

  @override
  State<EventsList> createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  Future getRecords() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Events"),
        ),
        body: FutureBuilder(
          future: getRecords(),
          builder: (context, snapshot) => Container(
            child: ListView(
              children: widget.records,
            ),
          ),
        ));
  }
}
