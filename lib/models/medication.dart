import 'dart:convert';
import 'package:flutter/material.dart';

class Medication {
  String name;
  DateTime lastTriggered;
  Duration interval;
  bool doAlarm;

  Medication({required this.name, required this.lastTriggered, required this.interval, this.doAlarm = false});

  Map<String, dynamic> toJson() => {
    'name': name,
    'lastTriggered': lastTriggered.toIso8601String(),
    'interval': interval.inMinutes,
    'doAlarm': doAlarm,
  };

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      name: json['name'],
      lastTriggered: DateTime.parse(json['lastTriggered']),
      interval: Duration(minutes: json['interval']),
      doAlarm: json['doAlarm'] ?? false, // Default to false if null
    );
  }

  // Optionally, convert a Medication instance to a JSON string
  String toJsonString() {
    return json.encode(toJson());
  }

  // Optionally, create a Medication instance from a JSON string
  factory Medication.fromJsonString(String jsonString) {
    return Medication.fromJson(json.decode(jsonString));
  }

}

typedef MedicationCallback = void Function(Medication med, bool delete);

class MedicationProvider with ChangeNotifier {
  List<Medication> _medications = [];

  List<Medication> get medications => _medications;

  void setMedications(List<Medication> meds) {
    _medications = meds;
    notifyListeners();
  }

  void addMedication(Medication med) {
    _medications.add(med);
    notifyListeners();
  }

  void updateMedication(Medication med) {
    int index = _medications.indexWhere((m) => m.name == med.name);
    if (index != -1) {
      _medications[index] = med;
      notifyListeners();
    }
  }
}