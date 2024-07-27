class Medication {
    final String name;
    final DateTime lastTriggered;
    final Duration interval;
    final bool doAlarm;

    Medication({required this.name, required this.lastTriggered, required this.interval, this.doAlarm = false});
}