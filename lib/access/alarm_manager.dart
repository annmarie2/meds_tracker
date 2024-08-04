import 'package:alarm/alarm.dart';
import 'dart:async';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class AlarmManager {
  static final AlarmManager _instance = AlarmManager._internal();
  static StreamSubscription<AlarmSettings>? subscription;
  late Function(AlarmSettings) onAlarmRing;

  factory AlarmManager() {
    return _instance;
  }

  AlarmManager._internal();

  Future<void> init(Function(AlarmSettings) alarmCallback) async {
    onAlarmRing = alarmCallback;
    await Alarm.init();
    if (Alarm.android) {
      await _checkAndroidNotificationPermission();
      await _checkAndroidScheduleExactAlarmPermission();
    }

    subscription ??= Alarm.ringStream.stream.listen((alarmSettings) {
      onAlarmRing(alarmSettings);
    });
  }

  Future<void> _checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      final res = await Permission.notification.request();
      print('Notification permission ${res.isGranted ? '' : 'not '}granted');
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
    // Clear all existing alarms
    var existingAlarms = await Alarm.getAlarms();
    for (var alarm in existingAlarms) {
      await Alarm.stop(alarm.id);
    }

    // Set new alarms
    var alarmsCopy = List<AlarmSettings>.from(alarms);
    for (var alarm in alarmsCopy) {
      await Alarm.set(alarmSettings: alarm);
    }
  }

  Future<void> stopAlarm(int id) async {
    await Alarm.stop(id);
  }

  List<AlarmSettings> getAlarms() {
    var alarms = Alarm.getAlarms();
    alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    return alarms;
  }
}
