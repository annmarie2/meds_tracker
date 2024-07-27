import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'med_list_tile.dart';
import 'edit_view.dart';
import 'models/medication.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: HomePage(),
      ),
    );
  }
}

class MainAppState extends ChangeNotifier {
  // TODO: Change this to a persisted list, instead of a hardcoded one
  var meds = <Medication>[
    Medication(name: "Tylenol", lastTriggered: DateTime.now(), interval: Duration(days: 1), doAlarm: false),
  ];
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainAppState>();

    if (appState.meds.isEmpty) {
      return Center(
        child: Text('No medications yet.'),
      );
    }

    return Scaffold(
            appBar: AppBar(
        title: Text('Medications'),
      ),
      body: ListView(
        children: [
          for (var med in appState.meds)
            MedListTile(
              name: med.name,
              lastTriggered: DateTime.now(),
              interval: Duration(days: 1),
              onEdit: () {
                // Handle edit button press
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditView(med: med),
                  ),
                );
              }
            ),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle add button press,
        },
        child: Icon(Icons.add),
        shape: CircleBorder(),
        // TODO: Add background color based on theme :)
      ),
    );
  }
}