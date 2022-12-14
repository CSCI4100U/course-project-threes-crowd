import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'LoadingSpinner.dart';
import 'Analytics.dart';
import 'EventTile.dart';
import 'EventModel.dart';
import 'UserModel.dart';
import 'EventForm.dart';

class EventsList extends StatefulWidget {
  EventsList({super.key});

  final cloud = EventModel();
  late final Stream<QuerySnapshot> eventStream = cloud.getEvents();
  final UserModel local_storage = UserModel();
  List<String> attendingEvents = [];

  @override
  State<EventsList> createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  @override
  void initState() {
    widget.local_storage.connect().then((value) async {
      widget.attendingEvents = await _loadEvents();
    });
  }

  Future<List<String>> _loadEvents() async {
    List<Map<String, Object?>> attend =
        await widget.local_storage.getAttending();
    return attend.map((row) => row["doc_id"] as String).toList();
  }

  Future<void> _updateAttending(String evt_id, DocumentReference ref) async {
    String? text;

    if (await widget.local_storage.isAttending(evt_id)) {
      await widget.cloud.updateAttendence(ref, false);
      await widget.local_storage.delAttendence(evt_id);
      text = AppLocalizations.of(context)!.attendenceDelete;
    } else {
      await widget.cloud.updateAttendence(ref, true);
      await widget.local_storage.attendEvent(evt_id);
      text = AppLocalizations.of(context)!.attendenceAdd;
    }

    SnackBar notif = SnackBar(
      content: Text(text),
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(notif);

    List<String> newEvts = await _loadEvents();

    setState(() {
      widget.attendingEvents = newEvts;
    });
  }

  void _onTapAdd(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => EventForm()));
  }

  void _onTapAnalytics(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => Analytics()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.events),
        actions: <Widget>[
          IconButton(
            onPressed: () => _onTapAdd(context),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () => _onTapAnalytics(context),
            icon: const Icon(Icons.analytics),
          )
        ],
      ),
      body: StreamBuilder(
        stream: widget.eventStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const LoadingSpinner();

          return FutureBuilder(
            future: _loadEvents(),
            builder: (context, future_snapshot) => Container(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  DocumentSnapshot doc = snapshot.data!.docs[index];
                  Map<String, dynamic> data =
                      doc.data()! as Map<String, dynamic>;

                  return EventTile(
                    title: data["title"],
                    location: data["location"],
                    ref: doc.reference,
                    attending: widget.attendingEvents.contains(doc.id),
                    updateAttending: () =>
                        _updateAttending(doc.id, doc.reference),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
