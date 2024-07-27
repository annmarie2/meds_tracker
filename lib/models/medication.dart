import 'dart:convert';

class Medication {
  final String name;
  final DateTime lastTriggered;
  final Duration interval;
  final bool doAlarm;

  Medication({
    required this.name,
    required this.lastTriggered,
    required this.interval,
    this.doAlarm = false
  });

  // Convert a Medication instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lastTriggered': lastTriggered.toIso8601String(),
      'interval': interval.inMilliseconds, // Store duration as milliseconds
      'doAlarm': doAlarm,
    };
  }

  // Create a Medication instance from a JSON object
  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      name: json['name'],
      lastTriggered: DateTime.parse(json['lastTriggered']),
      interval: Duration(milliseconds: json['interval']),
      doAlarm: json['doAlarm'] ?? false,
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
