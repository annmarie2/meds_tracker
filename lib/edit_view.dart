import 'package:flutter/material.dart';
import 'package:meds_tracker/main.dart';
import 'package:provider/provider.dart';
import 'models/medication.dart';
import 'package:intl/intl.dart';
import 'access/persistence.dart';
import 'dart:convert';

class EditView extends StatefulWidget {
  Medication? med;
  MedicationCallback? onMedicationChanged;

  EditView({required this.med, required this.onMedicationChanged});

  @override
  State<EditView> createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  late TextEditingController _durationController;
  late bool _alarm;
  late TextEditingController _lastTriggeredController;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.med?.name ?? 'New Medication',
    );
    _durationController = TextEditingController(
      text: ((widget.med?.interval.inMinutes ?? 60) / 60).toStringAsFixed(2),
    );
    _alarm = widget.med?.doAlarm ?? false;
    _lastTriggeredController = TextEditingController(
      text: DateFormat('MMMM d, yyyy - h:mm a').format(widget.med?.lastTriggered ?? DateTime.now()),
    );
  }

  Future<void> _save() async {
    double? hours = double.tryParse(_durationController.text);
    DateTime? lastTriggered = DateFormat('MMMM d, yyyy - h:mm a').parse(_lastTriggeredController.text);
    String? name = _nameController.text;
    String? oldName = widget.med?.name;

    if (hours != null) {
      setState(() {
        if (widget.med == null) {
          widget.med = Medication(
            name: name,
            lastTriggered: lastTriggered,
            interval: Duration(minutes: (hours * 60.0).toInt()),
            doAlarm: _alarm,
          );
        } else {
          widget.med!.name = name;
          widget.med!.lastTriggered = lastTriggered;
          widget.med!.interval = Duration(minutes: (hours * 60.0).toInt());
          widget.med!.doAlarm = _alarm;
        }
        widget.onMedicationChanged!(widget.med!, false);
      });

      Navigator.pop(context);
    }
  }

  Future<void> _delete() async {

    widget.onMedicationChanged!(widget.med!, true);

    Navigator.pop(context);
  }

  @override 
  Widget build(BuildContext context) {
    // var appState = context.watch<MainAppState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Medication',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          IntrinsicWidth(
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
              ),
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                color: Theme.of(context).colorScheme.primary,
              ),
              onChanged: (value) {},
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("Period: "),
                    SizedBox(width: 10),
                    IntrinsicWidth(
                      child: TextFormField(
                        controller: _durationController,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                        style: TextStyle(
                          fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                    SizedBox(width: 10),
                    Text('hours'),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text('Last taken: '),
                    SizedBox(width: 10),
                    IntrinsicWidth(
                      child: TextFormField(
                        controller: _lastTriggeredController,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                        style: TextStyle(
                          fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text('Alarm: '),
                    SizedBox(width: 10),
                    Checkbox(
                      value: _alarm,
                      onChanged: (bool? value) {
                        setState(() {
                          _alarm = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min, // Ensures the Row takes up only as much space as its children
              children: [
                ElevatedButton(
                  onPressed: _save,
                  child: Text('Save'),
                ),
                SizedBox(width: 40),
                ElevatedButton(
                  onPressed: _delete,
                  child: Text('Delete'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}