import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum NotificationPermissionState { unknown, granted, denied, notSupported }

class NotificationService {
  NotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  Future<NotificationPermissionState> initialize() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _plugin.initialize(settings: initializationSettings);
    return NotificationPermissionState.unknown;
  }
}
