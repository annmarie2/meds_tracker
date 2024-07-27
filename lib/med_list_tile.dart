import 'package:flutter/material.dart';
import 'models/medication.dart';

class MedListTile extends StatelessWidget {
  final Medication med;
  final VoidCallback onEdit;

  MedListTile({required this.med, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var nextDose = med.lastTriggered.add(med.interval);
    var timeUntilNextDose = nextDose.difference(now);
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: (timeUntilNextDose < Duration.zero) ? theme.colorScheme.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(8.0), // Add some padding for better appearance
        child: Row(
          mainAxisSize: MainAxisSize.min, // Ensure the Row takes up only as much space as needed
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: onEdit,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(med.name),
                Text('Next Dose: '), // TODO: Calculate when the next dose will be and display it here
              ],
            ),
          ],
        ),
      ),
    );
  }
}