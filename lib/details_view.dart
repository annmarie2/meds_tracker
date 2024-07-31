import 'package:flutter/material.dart';
import 'package:meds_tracker/main.dart';
import 'package:provider/provider.dart';
import 'models/medication.dart';

class DetailsView extends StatelessWidget {
  final Medication med;

  DetailsView({required this.med});

  @override 
  Widget build(BuildContext context) {
    var appState = context.watch<MainAppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Medication Details'),
      ),
      body: Column(
        children: [
          Text(med.name),
          Text('Next Dose:'),
          Text('[time of dose]'), // TODO: Calculate when the next dose will be and display it here (as a time, e.g. 3:00 PM)
          ElevatedButton(
            onPressed: () {
              // TODO: Update the medication's lastTriggered to now
            },
            child: Text('I took my meds'),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // TODO: Snooze the alarm for 5 minutes
                  },
                  child: Text('Snooze 5 min'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Skip (the alarm, I reckon)
                  },
                  child: Text('Skip'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}