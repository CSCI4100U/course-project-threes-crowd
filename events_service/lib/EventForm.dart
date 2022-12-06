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
        dateStart = DateTime.tryParse(snapshot['start']) ?? DateTime.now();
        dateEnd = DateTime.tryParse(snapshot['end']) ?? DateTime.now();
      });
    } else {
      dateStart = DateTime.now();
      dateEnd = DateTime.now();
    }
  }

  DocumentReference? ref;
  EventModel db = EventModel();

  final descController = TextEditingController();
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  DateTime dateStart = DateTime.parse("20221201");
  DateTime dateEnd = DateTime.parse("20221201");

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  String _dateCount = '';
  String _start = '';
  String _end = '';

  @override
  void initState() {
    _start = DateFormat('yyyy-MM-dd HHmm').format(widget.dateStart);
    _end = DateFormat('yyyy-MM-dd HHmm').format(widget.dateEnd);
    super.initState();
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _start =
            DateFormat('yyyy-MM-dd').format(args.value.startDate).toString()
            + _start.substring(10);
        _end = DateFormat('yyyy-MM-dd')
            .format(args.value.endDate ?? args.value.startDate)
            .toString()
            + _end.substring(10);
      } else if (args.value is DateTime) {
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      }
    });
  }

  Future<void> submitData() async {
    if (widget.ref == null) {
      // creating
      widget.db.addEvent(
        widget.titleController.text,
        widget.locationController.text,
        widget.descController.text,
        _start,
        _end,
      );
    } else {
      // editing
      await widget.db.editEvent(
          widget.ref!,
          widget.titleController.text,
          widget.locationController.text,
          widget.descController.text,
          _start,
          _end);
    }

    SnackBar notif = SnackBar(
      content: Text(
          "${AppLocalizations.of(context)!.eventSaved1} ${widget.titleController.text} ${AppLocalizations.of(context)!.eventSaved2}"),
    );

    ScaffoldMessenger.of(context).showSnackBar(notif);
  }

  void setTimeFromPrompt(BuildContext context, bool isStart) async {
    // Sets _start or _end to a time selected by a time picker
    String initial;

    if (isStart) {
      initial = _start;
    } else {
      initial = _end;
    }

    TimeOfDay? result = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.tryParse(initial) ?? DateTime.now())
    );

    setState(() {
      if (result != null) {
        if (isStart) {
          _start = DateFormat('yyyy-MM-dd HHmm').format(
              DateTime.tryParse("${_start.substring(0,11)}"
                  "${(result.hour / 10).floor()}${result.hour % 10}"
                  "${(result.minute / 10).floor()}${result.minute % 10}"
              )
                  ?? DateTime.now());
        } else {
          _end = DateFormat('yyyy-MM-dd HHmm').format(
              DateTime.tryParse("${_end.substring(0,11)}"
                  "${(result.hour / 10).floor()}${result.hour % 10}"
                  "${(result.minute / 10).floor()}${result.minute % 10}"
              )
                  ?? DateTime.now());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editEvent),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          TextField(
            controller: widget.titleController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.editTitle,
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

          // Time selection grid
          Row (
            children: <Widget>[
              Column (
                children: <Widget>[
                  Text(AppLocalizations.of(context)!.startTime),
                  TextButton(
                      onPressed: () => {setTimeFromPrompt(context, true)},
                      child: Text(DateFormat.jm().format(DateTime.tryParse(_start) ?? DateTime.now()))
                  )
                ],
              ),
              Column (
                children: <Widget>[
                  Text(AppLocalizations.of(context)!.endTime),
                  TextButton(
                      onPressed: () => {setTimeFromPrompt(context, false)},
                      child: Text(DateFormat.jm().format(DateTime.tryParse(_end) ?? DateTime.now()))
                  )
                ],
              )
            ],
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => submitData(),
        tooltip: AppLocalizations.of(context)!.submitEvent,
        child: const Icon(Icons.save),
      ),
    );
  }
}

