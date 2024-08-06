import 'package:alarm/alarm.dart';
import 'dart:async';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class AlarmManager {
  static final AlarmManager _instance = AlarmManager._internal();
  static StreamSubscription<AlarmSettings>? subscription;
  // late Function(AlarmSettings) onAlarmRing;

  factory AlarmManager() {
    return _instance;
  }

  AlarmManager._internal();

  Future<void> init(Function(AlarmSettings) alarmCallback) async {
    // onAlarmRing = alarmCallback;
    await Alarm.init();
    if (Alarm.android) {
      await _checkAndroidNotificationPermission();
      await _checkAndroidExternalStoragePermission();
      await _checkAndroidScheduleExactAlarmPermission();
    }

    subscription ??= Alarm.ringStream.stream.listen((alarmSettings) { // TODO: this is spamming callbacks. Find a better way to do this!!!
        // Invoke the callback
        alarmCallback(alarmSettings);
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

    var alarmsCopy = List<AlarmSettings>.from(alarms); 
    for (AlarmSettings alarm in alarmsCopy) {
      if (!existingAlarms.contains(alarm)) {
        await Alarm.set(alarmSettings: alarm);
      }
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
