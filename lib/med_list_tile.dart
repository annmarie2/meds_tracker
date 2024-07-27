import 'package:flutter/material.dart';

class MedListTile extends StatelessWidget {
  final String name;
  final DateTime lastTriggered;
  final Duration interval;
  final VoidCallback onEdit;

  MedListTile({required this.name, required this.lastTriggered, required this.interval, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text('Next Dose: '), // TODO: Calculate when the next dose will be and display it here
      leading: IconButton(
        icon: Icon(Icons.edit),
        onPressed: onEdit,
      ),
    );
  }
}