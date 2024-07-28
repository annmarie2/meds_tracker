import 'package:flutter/material.dart';
import 'package:meds_tracker/main.dart';
import 'package:provider/provider.dart';
import 'models/medication.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EditView extends StatefulWidget {
  Medication? med;

  EditView({required this.med});

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

    if (hours != null) {
      setState(() {
        widget.med = Medication(
          name: name,
          lastTriggered: lastTriggered,
          interval: Duration(minutes: (hours * 60).toInt()),
          doAlarm: _alarm,
          );
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? medsJson = prefs.getString('medications');
      List<dynamic> medsList = medsJson != null ? jsonDecode(medsJson) : [];

      // Find the index of the existing medication
      int index = medsList.indexWhere((med) => med['name'] == widget.med?.name);
      print("index is $index");

      if (index != -1) {
        // Replace the existing medication
        medsList[index] = widget.med?.toJson();
      } else {
        // Add the new medication if it doesn't exist
        medsList.add(widget.med?.toJson());
      }

      await prefs.setString('medications', jsonEncode(medsList));
      Navigator.pop(context);
    }
  }

  Future<void> _delete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? medsJson = prefs.getString('medications');
    List<dynamic> medsList = medsJson != null ? jsonDecode(medsJson) : [];

    // Find the index of the existing medication
    int index = medsList.indexWhere((med) => med['name'] == widget.med?.name);

    // If the medication exists, delete it
    if (index != -1) {
      // Delete the existing medication
      medsList.removeAt(index);
    }

    await prefs.setString('medications', jsonEncode(medsList));
    Navigator.pop(context);
  }

  @override 
  Widget build(BuildContext context) {
    // var appState = context.watch<MainAppState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Medication'),
      ),
      body: Column(
        children: [
          IntrinsicWidth(
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              style: TextStyle(
                fontSize: 24.0,
              ),
              onChanged: (value) {},
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Period: "),
              SizedBox(width: 10), // Add some space between the text and the input field
              IntrinsicWidth(
                child: TextFormField(
                  controller: _durationController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {},
                ),
              ),
              SizedBox(width: 10),
              Text('hours'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Last time taken: '),
              SizedBox(width: 10),
              IntrinsicWidth(
                child: TextFormField(
                  controller: _lastTriggeredController,
                  // initialValue: DateFormat('MMMM d, yyyy - h:mm a').format(widget.med.lastTriggered), // Display the time in a human-readable format                  
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    // TODO: Handle changes to the input field if necessary
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Alarm: '),
              SizedBox(width: 10),
              Checkbox(
                value: _alarm,
                onChanged: (bool? value) {
                  // TODO: Handle changes to the checkbox if necessary
                  setState(() {
                    _alarm = value ?? false;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _save,
                child: Text('Save'),
              ),
              ElevatedButton(
                onPressed: _delete,
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}