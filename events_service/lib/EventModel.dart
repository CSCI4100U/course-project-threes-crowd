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

  Future<List<Map>> getEventsList() async {
    QuerySnapshot snapshot = await eventsRef.get();
    List<DocumentSnapshot> doc_list = snapshot.docs;

    return doc_list.map((e) {
      return e.data() as Map;
    }).toList();
  }

  Future addEvent(String title, String location, String desc, String dateStart,
      String dateEnd) async {
    await eventsRef.add({
      'title': title,
      'location': location,
      'description': desc,
      'start': dateStart,
      'end': dateEnd,
      'attendence': 0,
    });
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

  // increments or decrements by one
  Future updateAttendence(DocumentReference ref, bool Add) async {
    DocumentSnapshot snapshot = await ref.get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    int attendence = data['attendence'] ?? 0;

    attendence = Add ? attendence++ : attendence--;

    return await ref.update({
      'attendence': attendence,
    });
  }

  Future deleteEvent(DocumentReference ref) async {
    return await ref.delete();
  }
}
