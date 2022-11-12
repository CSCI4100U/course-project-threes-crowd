import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_service/EventModel.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class EventForm extends StatefulWidget {
  EventForm({
    super.key,
    required DocumentReference? this.ref,
  }) {
    if (ref != null) {
      ref!.get().then((snapshot) {
        descController.text = snapshot['description'];
        titleController.text = snapshot['title'];
        locationController.text = snapshot['location'];
        dateStart = DateTime.parse(snapshot['start']);
        dateEnd = DateTime.parse(snapshot['end']);
      });
    }
  }

  DocumentReference? ref;
  EventModel db = EventModel();

  final descController = TextEditingController();
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  DateTime dateStart = DateTime.now();
  DateTime dateEnd = DateTime.now();

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  String _dateCount = '';
  String _start = '';
  String _end = '';

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _start =
            DateFormat('yyyy-MM-dd').format(args.value.startDate).toString();
        _end = DateFormat('yyyy-MM-dd')
            .format(args.value.endDate ?? args.value.startDate)
            .toString();
      } else if (args.value is DateTime) {
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      }
    });
  }

  Future<void> submitData() async {
    await widget.db.editEvent(
        widget.ref!,
        widget.titleController.text,
        widget.locationController.text,
        widget.descController.text,
        _start,
        _end);

    SnackBar notif = SnackBar(
      content: Text("Event ${widget.titleController.text} Saved"),
    );

    ScaffoldMessenger.of(context).showSnackBar(notif);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Event"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: widget.titleController,
              decoration: const InputDecoration(
                labelText: "Title",
              ),
            ),
            TextField(
              controller: widget.locationController,
              decoration: const InputDecoration(
                labelText: "Location",
              ),
            ),
            TextField(
              controller: widget.descController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
            ),
            const Text("Date"),
            SfDateRangePicker(
              onSelectionChanged: _onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.range,
              initialSelectedRange: PickerDateRange(
                widget.dateStart,
                widget.dateEnd,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => submitData(),
        tooltip: "Submit event",
        child: const Icon(Icons.save),
      ),
    );
  }
}
