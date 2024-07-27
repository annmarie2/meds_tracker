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
      body: Center(
        child: Text('Editing ${med.name}'),
      ),
    );
  }
}