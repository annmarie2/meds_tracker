import 'package:shared_preferences/shared_preferences.dart';
import 'package:meds_tracker/models/medication.dart';

class Persistence {
  static Future<void> saveData(List<Medication> medications) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> medicationsJson = medications.map((med) => med.toJsonString()).toList();
    await prefs.setStringList('medications', medicationsJson);
  }

  static Future<List<Medication>> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String>? medicationsJson = prefs.getStringList('medications');
    final List<Medication> medications = medicationsJson?.map((medJson) => Medication.fromJsonString(medJson)).toList() ?? [];
    return medications;
  }
}