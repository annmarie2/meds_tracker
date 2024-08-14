import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'med_list_tile.dart';
import 'edit_view.dart';
import 'models/medication.dart';
import 'access/persistence.dart';
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
      x.snooze = med.snooze;
    }
    if (delete) {
      meds.removeWhere((m) => m.id == med.id);
    }
    await Persistence.saveData(meds);
    if (med.doAlarm) {
      await AlarmManager().updateAlarm(med, delete);
    }
  }

  void updateMedicationStatus(AlarmSettings alarmSettings, bool change) async {
    Medication? med;
    try {
      med = meds.firstWhere((m) => m.name == alarmSettings.notificationTitle);
    } catch (e) {
      med = null;
    }

    if (med != null) {
      if (change) {
        med.snooze = false; // Ensure that snooze is false when medication is taken
        med.lastTriggered = DateTime.now();
      } else {
        med.snooze = true;
      }

      // Find the index of the med in the meds list and update it
      int index = meds.indexWhere((m) => m.id == med?.id);
      if (index != -1) {
        meds[index] = med;
      }

      await Persistence.saveData(meds);
      if (med.doAlarm) {
        await AlarmManager().updateAlarmStatus(med);
      }
    }
  }

  Future<void> _loadMeds() async {
    List<Medication> medsList = await Persistence.loadData();
    if (medsList.isNotEmpty) {
      meds = medsList.map((med) => med).toList();
    } else {
      meds = [];
    }
    notifyListeners();
    AlarmManager().createAlarms(meds);
  }

  Future<void> _navigateToRingScreen(AlarmSettings alarmSettings, Duration snoozeTime) async {
      // Use the current context from the nearest BuildContext
      var context = navigatorKey.currentContext;
      if (context != null) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlarmRingScreen(
              alarmSettings: alarmSettings,
              updateMedicationStatus: updateMedicationStatus,
              snoozeTime: snoozeTime,
            ),
          ),
        );
      }
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
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
    );
  }
}