import 'package:flutter/material.dart';
import 'models/medication.dart';
import 'package:intl/intl.dart';

class MedListTile extends StatelessWidget {
  final Medication med;
  final VoidCallback onEdit;
  final VoidCallback onTaken;

  MedListTile({required this.med, required this.onEdit, required this.onTaken});

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var nextDose = med.lastTriggered.add(med.interval);
    var timeUntilNextDose = nextDose.difference(now);
    final theme = Theme.of(context);

    return Center(
      child: IntrinsicWidth(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Container(
            decoration: BoxDecoration(
              color: (timeUntilNextDose <= Duration.zero) ? theme.colorScheme.primary : theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(15.0), // Add some padding for better appearance
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: onEdit,
                      color: (timeUntilNextDose <= Duration.zero) ? theme.colorScheme.onPrimary : theme.colorScheme.onPrimaryContainer,
                    ),
                    Center(
                      child: Text(
                        med.name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: (timeUntilNextDose <= Duration.zero) ? theme.colorScheme.onPrimary : theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.medication),
                      onPressed: onTaken,
                      color: (timeUntilNextDose <= Duration.zero) ? theme.colorScheme.onPrimary : theme.colorScheme.onPrimaryContainer,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Next Dose: ${DateFormat('MMM d, yyyy - h:mm a').format(med.lastTriggered.add(med.interval))}',
                  style: TextStyle(
                    color: (timeUntilNextDose <= Duration.zero) ? theme.colorScheme.onPrimary : theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}