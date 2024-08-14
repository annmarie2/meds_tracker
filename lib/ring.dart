import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'models/medication.dart';

class AlarmRingScreen extends StatelessWidget {
  final AlarmSettings alarmSettings;
  final Function(AlarmSettings, bool) updateMedicationStatus;
  final Duration snoozeTime;

  AlarmRingScreen({required this.alarmSettings, required this.updateMedicationStatus, required this.snoozeTime, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Alarm',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Time to take ${alarmSettings.notificationTitle}!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Text('🔔', style: TextStyle(fontSize: 50)),
              ElevatedButton(
                onPressed: () {
                  updateMedicationStatus(alarmSettings, false);
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5);
                      }
                      return Theme.of(context).colorScheme.primaryContainer; // Use the component's default.
                    },
                  ),
                ),
                child: Text(
                  'Snooze for ${snoozeTime.inMinutes} minutes',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  updateMedicationStatus(alarmSettings, true);
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5);
                      }
                      return Theme.of(context).colorScheme.primaryContainer; // Use the component's default.
                    },
                  ),
                ),
          
                child: Text(
                  'I took my medicine',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
