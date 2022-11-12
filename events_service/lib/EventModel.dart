import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class EventModel {
  late FirebaseFirestore firestore;
  late CollectionReference eventsRef;

  EventModel() {
    firestore = FirebaseFirestore.instance;
    eventsRef = firestore.collection("events");
  }

  Stream<QuerySnapshot<Object?>> getEvents() {
    return eventsRef.snapshots();
  }

  Future addEvent(String title, String location) async {
    await eventsRef.add({'title': title, 'location': location});
  }

  Future editEvent(DocumentReference ref, String title, String location,
      String desc, String dateStart, String dateEnd) async {
    return await ref.update({
      'title': title,
      'location': location,
      'description': desc,
      'start': dateStart,
      'end': dateEnd,
    });
  }

  Future deleteEvent(DocumentReference ref) async {
    return await ref.delete();
  }
}
