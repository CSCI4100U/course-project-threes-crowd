import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:events_service/EventView.dart';
import 'package:events_service/UserModel.dart';
import 'package:flutter/material.dart';

class EventTile extends StatelessWidget {
  const EventTile({
    super.key,
    required this.title,
    required this.location,
    required this.ref,
    required this.attending,
    required this.updateAttending,
  });

  final DocumentReference ref;
  final String title;
  final String location;
  final bool attending;
  final Function updateAttending;

  void _onTapTile(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => EventView(
                  title: title,
                  ref: ref,
                )));
  }

  @override
  Widget build(BuildContext context) {
    Widget icon = attending
        ? const Icon(Icons.radio_button_checked)
        : const Icon(Icons.radio_button_unchecked);
    return Card(
      child: GestureDetector(
        onTap: () => _onTapTile(context),
        child: ListTile(
          title: Text(title),
          subtitle: Text(location),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.attending),
              GestureDetector(
                onTap: () => updateAttending(),
                child: icon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
