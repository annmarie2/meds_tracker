class Medication {
  final String name;
  final DateTime lastTriggered;
  final Duration interval;
  final bool doAlarm;

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
      doAlarm: json['alarm'],
    );
  }
}