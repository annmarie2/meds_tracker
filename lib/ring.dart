import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'models/medication.dart';

class ExampleAlarmRingScreen extends StatelessWidget {
  final AlarmSettings alarmSettings;
  final Function(String, bool) updateMedicationStatus;
  final Duration snoozeTime;

  ExampleAlarmRingScreen({required this.alarmSettings, required this.updateMedicationStatus, required this.snoozeTime, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    updateMedicationStatus(alarmSettings.notificationTitle, false);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Snooze',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                RawMaterialButton(
                  onPressed: () {
                    updateMedicationStatus(alarmSettings.notificationTitle, true);
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
