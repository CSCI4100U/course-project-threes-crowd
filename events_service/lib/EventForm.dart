import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_service/EventModel.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class EventForm extends StatefulWidget {
  EventForm({
    super.key,
    this.ref,
  }) {
    if (ref != null) {
      ref!.get().then((snapshot) {
        descController.text = snapshot['description'];
        titleController.text = snapshot['title'];
        locationController.text = snapshot['location'];
        attendenceCapController.text = snapshot['attendenceCap'].toString();
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
  final attendenceCapController = TextEditingController();
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
    print(widget.attendenceCapController.text);
    if (widget.ref == null) {
      // creating
      widget.db.addEvent(
        widget.titleController.text,
        widget.locationController.text,
        widget.descController.text,
        _start,
        _end,
        int.tryParse(widget.attendenceCapController.text) ?? 0,
      );
    } else {
      // editing
      await widget.db.editEvent(
        widget.ref!,
        widget.titleController.text,
        widget.locationController.text,
        widget.descController.text,
        _start,
        _end,
        int.tryParse(widget.attendenceCapController.text) ?? 0,
      );
    }

    SnackBar notif = SnackBar(
      content: Text(
          "${AppLocalizations.of(context)!.eventSaved1} ${widget.titleController.text} ${AppLocalizations.of(context)!.eventSaved2}"),
    );

    ScaffoldMessenger.of(context).showSnackBar(notif);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editEvent),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: widget.titleController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.editTitle,
              ),
            ),
            TextField(
              controller: widget.attendenceCapController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.attendenceCap,
              ),
            ),
            TextField(
              controller: widget.locationController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.editLocation,
              ),
            ),
            TextField(
              controller: widget.descController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.editDesc,
              ),
            ),
            Text(AppLocalizations.of(context)!.editDate),
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
        tooltip: AppLocalizations.of(context)!.submitEvent,
        child: const Icon(Icons.save),
      ),
    );
  }
}
