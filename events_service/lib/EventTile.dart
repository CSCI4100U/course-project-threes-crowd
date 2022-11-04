import 'package:events_service/EventView.dart';
import 'package:flutter/material.dart';
import './EventView.dart';

class EventTile extends StatelessWidget {
  const EventTile({
    super.key,
    required String this.title,
    required String this.location,
  });

  final String title;
  final String location;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EventView(
                    title: title,
                    location: location,
                  ))),
      child: ListTile(
        title: Text(title),
        subtitle: Text(location),
      ),
    );
  }
}
