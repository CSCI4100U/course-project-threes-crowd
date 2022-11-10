import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_service/EventView.dart';
import 'package:events_service/UserModel.dart';
import 'package:flutter/material.dart';

class EventTile extends StatelessWidget {
  EventTile({
    super.key,
    required String this.title,
    required String this.location,
    required DocumentReference<Object?> this.ref,
    required bool this.attending,
    required Function this.updateAttending,
  });

  final DocumentReference ref;
  final String title;
  final String location;
  final bool attending;
  final Function updateAttending;

  void onTapTile(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => EventView(
                  title: title,
                  ref: ref,
                )));
  }

  // Future<bool> isAttending() async {
  //   // results in mutliple connection calls. how to await for these calls on init?
  //   await local_storage.connect();
  //   return await local_storage.isAttending(evt_id);
  // }

  // void onTapAttending() async {
  //   if (await local_storage.isAttending(evt_id)) {
  //     print("del");
  //     await local_storage.delAttendence(evt_id);
  //   } else {
  //     await local_storage.attendEvent(evt_id);
  //     print("add");
  //   }
  //   await isAttending();
  // }

  @override
  Widget build(BuildContext context) {
    IconData icon =
        attending ? Icons.radio_button_checked : Icons.radio_button_unchecked;
    return Card(
      child: GestureDetector(
        onTap: () => onTapTile(context),
        child: ListTile(
          title: Text(title),
          subtitle: Text(location),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Attending?"),
              GestureDetector(
                onTap: () => updateAttending(),
                child: Icon(icon),
              )
            ],
          ),
        ),
      ),
    );

    // return FutureBuilder(
    //   future: isAttending(),
    //   initialData: false,
    //   builder: ((context, snapshot) {
    // if (snapshot.hasError) print(snapshot.error);

    // return Row(
    //   children: <Widget>[
    //     Expanded(
    //       child: ListTile(
    //         title: Text(title),
    //         subtitle: Text(location),
    //       ),
    //     ),
    //     // Column(children: [

    //     // ],)
    //     // GestureDetector(
    //     //   onTap: () => onTap(context),
    //     //   child: ListTile(
    //     //     title: Text(title),
    //     //     subtitle: Text(location),
    //     //   ),
    //     // ),
    //     Column(
    //       children: <Widget>[
    //         const Text("Attending?"),
    //         Icon(icon),
    //       ],
    //     ),
    //   ],
    // );
    //   }),
    // );
  }
}
