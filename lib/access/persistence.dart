import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meds_tracker/models/medication.dart';

class Persistence {
  static Future<void> saveData(List<Medication> medications) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> medicationsJson = medications.map((med) => med.toJsonString()).toList();
    await prefs.setStringList('medications_v2', medicationsJson);
  }

  static Future<List<Medication>> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? medicationsJson = prefs.getStringList('medications_v2');
    final List<Medication> medications = medicationsJson?.map((medJson) => Medication.fromJsonString(medJson)).toList() ?? [];

    //Support for old versions of data
    String? medsJson = prefs.getString('medications');
    if (medsJson != null) {
      List<dynamic> medsList = jsonDecode(medsJson);
      var meds = medsList.map((med) => Medication.fromJson(med)).toList();
      medications.addAll(meds);
    }
    
    return medications;
  }
}