import 'package:alarm/alarm.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import '../models/medication.dart';

class AlarmManager {
  static final AlarmManager _instance = AlarmManager._internal();
  static StreamSubscription<AlarmSettings>? subscription;
  final Set<int> processedAlarms = <int>{};
  final Duration snoozeTime = Duration(minutes: 10);

  factory AlarmManager() {
    return _instance;
  }

  AlarmManager._internal();

  Future<void> init(Function(AlarmSettings, Duration) alarmCallback) async {
    await Alarm.init();
    if (Alarm.android) {
      // TODO: get the phone to vibrate, too
      await _checkAndroidNotificationPermission();
      await _checkAndroidExternalStoragePermission();
      await _checkAndroidScheduleExactAlarmPermission();
    }

    subscription ??= Alarm.ringStream.stream.listen((alarmSettings) {
      // Check if the alarm has already been processed
      if (!processedAlarms.contains(alarmSettings.id)) {
        // Invoke the callback
        alarmCallback(alarmSettings, snoozeTime);
        // Add the alarm to the set of processed alarms
        processedAlarms.add(alarmSettings.id);
      }
    });
  }

  Future<void> _checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      final res = await Permission.notification.request();
      print('Notification permission ${res.isGranted ? '' : 'not '}granted');
    }
  }

  Future<void> _checkAndroidExternalStoragePermission() async {
    final status = await Permission.storage.status;
    if (status.isDenied) {
      alarmPrint('Requesting external storage permission...');
      final res = await Permission.storage.request();
      alarmPrint(
        'External storage permission ${res.isGranted ? '' : 'not'} granted',
      );
    }
  }

  Future<void> _checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    if (status.isDenied) {
      final res = await Permission.scheduleExactAlarm.request();
      print('Schedule exact alarm permission ${res.isGranted ? '' : 'not '}granted');
    }
  }

  Future<void> createAlarms(List<Medication> meds) async {
    List<AlarmSettings> alarms = [];
    
    for (Medication med in meds) {
      if (med.doAlarm == true) {
        AlarmSettings alarm = AlarmSettings(
          id: med.id.hashCode, // Use medication ID to ensure unique alarms
          dateTime: med.snooze == false ? med.lastTriggered.add(med.interval) : med.lastTriggered.add(med.interval).add(snoozeTime),
          vibrate: true, // TODO: Vibrate isn't working; fix that
          notificationTitle: med.name,
          notificationBody: 'Time to take your medication!',
          assetAudioPath: 'assets/audio/alarm.wav',
        );
        alarms.add(alarm);
      }
    }
    await setAlarms(alarms);
  }

  Future<void> setAlarms(List<AlarmSettings> alarms) async {
    var existingAlarms = getAlarms();

    // set any new alarms in the list (updating/deleting alarms happens elsewhere!)
    for (AlarmSettings alarm in alarms) {
      // if that alarm already exists, do nothing. updating alarms will happen explicitely, otherwise we'd be re-setting alarms constantly :)
      if (existingAlarms.any((existingAlarm) => existingAlarm.id == alarm.id)) {
        // carry on
      } else {
        await Alarm.set(alarmSettings: alarm);
      }
    }

    // Clear processed alarms to avoid interference with newly set alarms
    processedAlarms.clear();
  }

  Future<void> updateAlarmStatus(Medication med) async {
    var alarms = getAlarms();
    var alarm = alarms.firstWhere((alarm) => alarm.notificationTitle == med.name);
    final now = DateTime.now();

    if (med.snooze == true) {
      // Snooze the alarm
      Alarm.stop(alarm.id);
      Alarm.set(
        alarmSettings: alarm.copyWith(
          dateTime: DateTime(
            now.year,
            now.month,
            now.day,
            now.hour,
            now.minute,
          ).add(snoozeTime),
        ),
      );
    } else {
      // Dismiss the alarm
      Alarm.stop(alarm.id);
    }
  }

  Future<void> updateAlarm(Medication med, bool delete) async {
    var alarms = getAlarms();
    var alarm = null;

    for (AlarmSettings existingAlarm in alarms) {
      if (existingAlarm.notificationTitle == med.name) {
        alarm = existingAlarm;
      }
    }

    if (alarm == null) {
      createAlarms([med]);
      return;
    }

    await Alarm.stop(alarm.id);
    if (delete == false) {
      // set the alarm
      // TODO: prolly should just call createAlarms()
      AlarmSettings alarm = AlarmSettings(
        id: med.id.hashCode, // Use medication ID to ensure unique alarms
        dateTime: med.snooze == false ? med.lastTriggered.add(med.interval) : med.lastTriggered.add(med.interval).add(snoozeTime),
        vibrate: true,
        notificationTitle: med.name,
        notificationBody: 'Time to take your medication!',
        assetAudioPath: 'assets/audio/alarm.wav',
      );
      alarms.add(alarm);
    }
  }

  List<AlarmSettings> getAlarms() {
    List<AlarmSettings> alarms = [];
    try {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    } on Exception catch (e) {
      alarmPrint('Error getting alarms: $e');
    }
    return alarms;
  }
}