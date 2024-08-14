import 'package:flutter/material.dart';
import 'package:meds_tracker/main.dart';
import 'package:provider/provider.dart';
import 'models/medication.dart';
import 'package:alarm/alarm.dart';

class DetailsView extends StatelessWidget {
  final AlarmSettings alarmSettings;
  final Function(AlarmSettings, bool) updateMedicationStatus;
  final Duration snoozeTime;

  DetailsView({required this.alarmSettings, required this.updateMedicationStatus, required this.snoozeTime, super.key});

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alarm'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'You alarm for ${alarmSettings.notificationTitle} is ringing...',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Text('🔔', style: TextStyle(fontSize: 50)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RawMaterialButton(
                  onPressed: () {
                    updateMedicationStatus(alarmSettings, false);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Snooze for ${snoozeTime.inMinutes} minutes',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                RawMaterialButton(
                  onPressed: () {
                    updateMedicationStatus(alarmSettings, true);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'I took my medicine',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}