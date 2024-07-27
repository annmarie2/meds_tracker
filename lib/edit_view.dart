import 'package:flutter/material.dart';
import 'package:meds_tracker/main.dart';
import 'package:provider/provider.dart';
import 'models/medication.dart';

class EditView extends StatelessWidget {
  final Medication med;

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
          Text('${med.name}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Period: "),
              SizedBox(width: 10), // Add some space between the text and the input field
              IntrinsicWidth(
                child: TextFormField(
                  initialValue: med.interval.toString(), // TODO: Display the interval in a human-readable format
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    // TODO: Handle changes to the input field if necessary
                  },
                ),
              ),
              // TODO: Add a dropdown to select the period (e.g. days, hours, minutes)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Last time taken: '),
              SizedBox(width: 10),
              IntrinsicWidth(
                child: TextFormField(
                  initialValue: med.lastTriggered.toString(), // TODO: Display the time in a human-readable format
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