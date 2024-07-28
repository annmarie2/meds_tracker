import 'package:flutter/material.dart';
import 'package:meds_tracker/main.dart';
import 'package:provider/provider.dart';
import 'models/medication.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EditView extends StatelessWidget {
  Medication med;

  EditView({required this.med});

  @override 
  Widget build(BuildContext context) {
    var appState = context.watch<MainAppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Medication'),
      ),
      body: Column(
        children: [
          Text(
            '${med.name}',
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
                  initialValue: (med.interval.inMinutes / 60).toStringAsFixed(2), // Display the interval in hours up to the hundredths decimal place
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
                  initialValue: DateFormat('MMMM d, yyyy - h:mm a').format(med.lastTriggered), // Display the time in a human-readable format                  
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
                value: med.doAlarm,
                onChanged: (value) {
                  // TODO: Handle changes to the checkbox if necessary
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // TODO: Handle the save button press
                  // TODO: Take input from fields, if valid, turn into a new Medication object and replace the old one

                },
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