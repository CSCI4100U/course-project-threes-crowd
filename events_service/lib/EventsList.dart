import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'EventTile.dart';
import 'EventModel.dart';

class EventsList extends StatefulWidget {
  EventsList({super.key});

  final cloud = EventModel();
  late final Stream<QuerySnapshot> eventStream = cloud.getEvents();

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
          actions: const <Widget>[],
        ),
        body: StreamBuilder(
            stream: widget.eventStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return const Text("Loading...");

              return Container(
                child: ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot doc) {
                    Map<String, dynamic> data =
                        doc.data()! as Map<String, dynamic>;

                    return EventTile(
                      title: data["title"],
                      location: data["location"],
                      ref: doc.reference,
                    );
                  }).toList(),
                ),
              );
            }));
  }
}
