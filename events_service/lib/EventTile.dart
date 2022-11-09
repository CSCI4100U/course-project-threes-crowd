import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_service/EventView.dart';
import 'package:flutter/material.dart';
import './EventView.dart';

class EventTile extends StatelessWidget {
  const EventTile({
    super.key,
    required String this.title,
    required String this.location,
    required DocumentReference<Object?> this.ref,
  });

  final DocumentReference ref;
  final String title;
  final String location;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => EventView(
                    title: title,
                    ref: ref,
                  ))),
      child: ListTile(
        title: Text(title),
        subtitle: Text(location),
      ),
    );
  }
}
