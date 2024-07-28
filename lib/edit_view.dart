import 'package:flutter/material.dart';
import 'package:meds_tracker/main.dart';
import 'package:provider/provider.dart';
import 'models/medication.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EditView extends StatefulWidget {
  Medication med;

  EditView({required this.med});

  @override
  State<EditView> createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  late TextEditingController _durationController;
  late bool _alarm;
  late TextEditingController _lastTriggeredController;

  @override
  void initState() {
    super.initState();
    _durationController = TextEditingController(
      text: (widget.med.interval.inMinutes / 60).toStringAsFixed(2),
    );
    _alarm = widget.med.doAlarm;
    _lastTriggeredController = TextEditingController(
      text: DateFormat('MMMM d, yyyy - h:mm a').format(widget.med.lastTriggered),
    );
  }

  Future<void> _save() async {
    double? hours = double.tryParse(_durationController.text);

    if (hours != null) {
      setState(() {
        widget.med = Medication(
          name: widget.med.name,
          lastTriggered: widget.med.lastTriggered,
          interval: Duration(minutes: (hours * 60).toInt()),
          doAlarm: _alarm,
          );
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? medsJson = prefs.getString('medications');
      List<dynamic> medsList = medsJson != null ? jsonDecode(medsJson) : [];

      // Find the index of the existing medication
      // TODO: THIS IS ALWAYS RETURNING 0. WHY?
      int index = medsList.indexWhere((med) => med['name'] == widget.med.name);
      print("index is $index");

      if (index != -1) {
        // Replace the existing medication
        medsList[index] = widget.med.toJson();
      } else {
        // Add the new medication if it doesn't exist
        medsList.add(widget.med.toJson());
      }

      // medsList.add(widget.med.toJson());
      await prefs.setString('medications', jsonEncode(medsList));
    }
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
          Text(
            '${widget.med.name}',
            style: TextStyle(
              fontSize: 24.0,
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
                  onChanged: (value) {
                    // TODO: Handle changes to the input field if necessary
                  },
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
                onPressed: () {
                  // TODO: Handle the delete button press
                  
                },
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}