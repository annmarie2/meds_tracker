import 'package:alarm/alarm.dart';
import 'dart:async';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import '../models/medication.dart';

class AlarmManager {
  static final AlarmManager _instance = AlarmManager._internal();
  static StreamSubscription<AlarmSettings>? subscription;
  final Set<int> processedAlarms = <int>{};
  final Duration snoozeTime = Duration(minutes: 3);

  factory AlarmManager() {
    return _instance;
  }

  AlarmManager._internal();

  Future<void> init(Function(AlarmSettings) alarmCallback) async {
    await Alarm.init();
    if (Alarm.android) {
      await _checkAndroidNotificationPermission();
      await _checkAndroidExternalStoragePermission();
      await _checkAndroidScheduleExactAlarmPermission();
    }

    subscription ??= Alarm.ringStream.stream.listen((alarmSettings) {
      // Check if the alarm has already been processed
      if (!processedAlarms.contains(alarmSettings.id)) {
        // Invoke the callback
        alarmCallback(alarmSettings);
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

  Future<void> setAlarms(List<AlarmSettings> alarms) async {
    var existingAlarms = getAlarms();

    // Stop all alarms first to avoid overlaps and re-triggering issues
    for (AlarmSettings existingAlarm in existingAlarms) {
        await Alarm.stop(existingAlarm.id);
    }

    // Set new alarms
    for (AlarmSettings alarm in alarms) {
        await Alarm.set(alarmSettings: alarm);
    }

    // Clear processed alarms to avoid interference with newly set alarms
    processedAlarms.clear();
  }

  Future<void> stopAlarm(int id) async {
    await Alarm.stop(id);
  }

  Future<void> stopAllAlarms() async {
    await Alarm.stopAll();
  }

  List<AlarmSettings> getAlarms() {
    var alarms = Alarm.getAlarms();
    alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    return alarms;
  }
}