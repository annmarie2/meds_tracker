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
      subtitle: Text('Dosage: '),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: onEdit,
      ),
    );
  }
}