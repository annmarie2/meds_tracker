import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'med_list_tile.dart';
import 'edit_view.dart';
import 'models/medication.dart';
import 'details_view.dart';
import 'access/persistence.dart';
import 'dart:convert';
import 'access/alarm_manager.dart';
import 'ring.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => MainAppState(),
    child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {    
    return ChangeNotifierProvider(
      create: (context) => MainAppState(),
      child: MaterialApp(
        title: 'Meds App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange,
          ),
        ),
        home: HomePage(),
        navigatorKey: navigatorKey,
      ),
    );
  }
}

class MainAppState extends ChangeNotifier {
  var meds = <Medication>[];
  List<AlarmSettings> _alarms = []; // alarms are stored in main.dart
  List<AlarmSettings> get alarms => _alarms; // TODO: is this line necessary??
  final Set<int> processedAlarms = <int>{};

  MainAppState() {
    _loadMeds();
    AlarmManager().init(_navigateToRingScreen);
  }

  void updateMedication(Medication med, bool delete) async {
    bool isNew = !(meds.any((m) => m.id == med.id));
    if (isNew) {
      meds.add(med);
    }
    else {
      var x = meds.firstWhere((m) => m.id == med.id);
      x.name = med.name;
      x.lastTriggered = med.lastTriggered;
      x.interval = med.interval;
      x.doAlarm = med.doAlarm;
    }
    if (delete) {
      meds.removeWhere((m) => m.id == med.id);
    }
    await Persistence.saveData(meds);
    _loadAlarmsFromMeds(); // Ensure alarms are updated when medications change
  }

  Future<void> _loadMeds() async {
    List<Medication> medsList = await Persistence.loadData();
    if (medsList.isNotEmpty) {
      meds = medsList.map((med) => med).toList();
    } else {
      meds = [];
    }
    notifyListeners();
    _loadAlarmsFromMeds(); // Ensure alarms are loaded when medications are loaded
  }

  Future<void> _navigateToRingScreen(AlarmSettings alarmSettings) async {
    // Check if the alarm has already been processed
    if (!processedAlarms.contains(alarmSettings.id)) {
      // Add the alarm to the set of processed alarms
      processedAlarms.add(alarmSettings.id);

      // Use the current context from the nearest BuildContext
      var context = navigatorKey.currentContext;
      if (context != null) {
        await Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => ExampleAlarmRingScreen(alarmSettings: alarmSettings),
          ),
        );
        _loadAlarms();
      }
    }
  }

  Future<void> _loadAlarmsFromMeds() async {
    _alarms.clear(); // Clear existing alarms to avoid duplicates
    for (Medication med in meds) {
      if (med.doAlarm == true) {
        AlarmSettings alarm = AlarmSettings(
          id: med.id.hashCode, // Use medication ID to ensure unique alarms
          dateTime: med.lastTriggered.add(med.interval),
          notificationTitle: med.name,
          notificationBody: 'Time to take your medication!',
          assetAudioPath: 'assets/audio/alarm.wav',
        );
        _alarms.add(alarm);
      }
    }
    await AlarmManager().setAlarms(_alarms);
    _loadAlarms();
    print("your current alarms are: ${alarms}");
  }

  void _loadAlarms() {
    _alarms = AlarmManager().getAlarms();
    notifyListeners();
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(); // TODO: DO THIS WITHOUT A GLOBAL KEY!!

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override 
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<MainAppState>(context, listen: false)._loadMeds();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainAppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Medications',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        children: appState.meds.isEmpty
          ? [
              Center(
                child: Text('No medications yet.'),
              ),
            ]
      : appState.meds.map((med) {
          return MedListTile(
            med: med,
            onEdit: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditView(med: med, onMedicationChanged: appState.updateMedication),
                ),
              );
            },
            onTaken: () {
              med.lastTriggered = DateTime.now();
              appState.updateMedication(med, false);
            },
          );
        }).toList(),
      ),      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditView(med: null, onMedicationChanged: appState.updateMedication),
            ),
          );
        },
        child: Icon(Icons.add),
        shape: CircleBorder(),
        // TODO: Add background color based on theme :)
      ),
    );
  }
}