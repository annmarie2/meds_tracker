import 'package:flutter/material.dart';
import 'package:meds_tracker/main.dart';
import 'package:provider/provider.dart';

class EditView extends StatelessWidget {

  @override 
  Widget build(BuildContext context) {
    var appState = context.watch<MainAppState>();

    if (appState.meds.isEmpty) {
      return Center(
        child: Text('No medications yet.'),
      );
    }

    return ListView(
      children: [
        for (var med in appState.meds)
          ListTile(
            title: Text(med.name),
          ),
      ]
    );
  }
}