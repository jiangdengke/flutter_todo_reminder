import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../features/shared/presentation/demo_task_data.dart';

enum NotificationPermissionState { unknown, granted, denied, notSupported }

class NotificationService extends ChangeNotifier {
  NotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const reminderChannelId = 'task_reminders';
  static const reminderChannelName = 'Task Reminders';
  static const reminderChannelDescription =
      'Scheduled reminders for planned tasks';

  final FlutterLocalNotificationsPlugin _plugin;

  NotificationPermissionState _permissionState =
      NotificationPermissionState.unknown;
  String? _pendingRoute;

  NotificationPermissionState get permissionState => _permissionState;

  Future<NotificationPermissionState> initialize() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
      macOS: DarwinInitializationSettings(),
      linux: LinuxInitializationSettings(
        defaultActionName: 'Open notification',
      ),
    );

    try {
      await _plugin.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: _handleNotificationResponse,
      );
      await _createAndroidChannel();
      await _captureLaunchRoute();
      _permissionState = await _resolvePermissionState();
    } on MissingPluginException {
      _permissionState = NotificationPermissionState.notSupported;
    }

    notifyListeners();
    return _permissionState;
  }

  Future<NotificationPermissionState> requestPermissions() async {
    try {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          final android = _plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
          await android?.requestNotificationsPermission();
          _permissionState = await _resolvePermissionState();
          break;
        case TargetPlatform.iOS:
          final ios = _plugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >();
          final granted = await ios?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
          _permissionState = granted == true
              ? NotificationPermissionState.granted
              : NotificationPermissionState.denied;
          break;
        case TargetPlatform.macOS:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          _permissionState = NotificationPermissionState.notSupported;
          break;
        default:
          _permissionState = NotificationPermissionState.notSupported;
          break;
      }
    } on MissingPluginException {
      _permissionState = NotificationPermissionState.notSupported;
    }

    notifyListeners();
    return _permissionState;
  }

  String? consumePendingRoute() {
    final route = _pendingRoute;
    _pendingRoute = null;
    return route;
  }

  Future<void> syncTaskReminders(List<DemoTask> tasks) async {
    if (!_supportsScheduling) {
      return;
    }

    try {
      final pending = await _plugin.pendingNotificationRequests();
      for (final request in pending) {
        await _plugin.cancel(id: request.id);
      }

      for (final task in tasks) {
        final scheduledFor = _scheduledDateTimeFor(task);
        if (scheduledFor == null || task.isDone) {
          continue;
        }
        if (!scheduledFor.isAfter(DateTime.now())) {
          continue;
        }

        final requestId = _stableNotificationId(task.id);
        final payload = jsonEncode(<String, String>{
          'taskId': task.id,
          'route': '/task/${task.id}',
        });

        await _plugin.zonedSchedule(
          id: requestId,
          scheduledDate: tz.TZDateTime.from(scheduledFor, tz.local),
          notificationDetails: _notificationDetails(task.accent),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          title: task.title.resolveByCode(_languageCode),
          body: _notificationBody(task),
          payload: payload,
        );
      }
    } on MissingPluginException {
      return;
    }
  }

  Future<void> _createAndroidChannel() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return;
    }

    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (android == null) {
      return;
    }

    const channel = AndroidNotificationChannel(
      reminderChannelId,
      reminderChannelName,
      description: reminderChannelDescription,
      importance: Importance.high,
    );

    await android.createNotificationChannel(channel);
  }

  Future<void> _captureLaunchRoute() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp != true) {
      return;
    }
    _queueRouteFromPayload(details?.notificationResponse?.payload);
  }

  Future<NotificationPermissionState> _resolvePermissionState() async {
    try {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          final android = _plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
          final enabled = await android?.areNotificationsEnabled();
          if (enabled == null) {
            return NotificationPermissionState.unknown;
          }
          return enabled
              ? NotificationPermissionState.granted
              : NotificationPermissionState.denied;
        case TargetPlatform.iOS:
          return NotificationPermissionState.unknown;
        case TargetPlatform.macOS:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          return NotificationPermissionState.notSupported;
        default:
          return NotificationPermissionState.notSupported;
      }
    } on MissingPluginException {
      return NotificationPermissionState.notSupported;
    }
  }

  NotificationDetails _notificationDetails(Color accent) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        reminderChannelId,
        reminderChannelName,
        channelDescription: reminderChannelDescription,
        importance: Importance.high,
        priority: Priority.high,
        category: AndroidNotificationCategory.reminder,
        channelShowBadge: true,
        color: accent,
        playSound: true,
        enableVibration: true,
      ),
    );
  }

  void _handleNotificationResponse(NotificationResponse response) {
    _queueRouteFromPayload(response.payload);
  }

  void _queueRouteFromPayload(String? payload) {
    if (payload == null || payload.isEmpty) {
      return;
    }

    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) {
        final route = decoded['route'];
        if (route is String && route.isNotEmpty) {
          _pendingRoute = route;
          notifyListeners();
          return;
        }
      }
    } catch (_) {
      if (payload.startsWith('/')) {
        _pendingRoute = payload;
        notifyListeners();
      }
    }
  }

  DateTime? _scheduledDateTimeFor(DemoTask task) {
    final plannedFor = task.plannedFor;
    final reminderLabel = task.reminderLabel;
    if (plannedFor == null || reminderLabel == null) {
      return null;
    }

    final parts = reminderLabel.split(':');
    if (parts.length != 2) {
      return null;
    }

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) {
      return null;
    }

    return DateTime(
      plannedFor.year,
      plannedFor.month,
      plannedFor.day,
      hour,
      minute,
    );
  }

  String _notificationBody(DemoTask task) {
    final note = task.note.resolveByCode(_languageCode).trim();
    if (note.isNotEmpty) {
      return note;
    }
    final reminderLabel = task.reminderLabel;
    if (reminderLabel != null) {
      return _languageCode == 'zh'
          ? '提醒时间 $reminderLabel'
          : 'Reminder at $reminderLabel';
    }
    return _languageCode == 'zh' ? '任务提醒' : 'Task reminder';
  }

  int _stableNotificationId(String taskId) {
    var hash = 0;
    for (final codeUnit in taskId.codeUnits) {
      hash = 0x1fffffff & (hash + codeUnit);
      hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
      hash ^= (hash >> 6);
    }
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash ^= (hash >> 11);
    hash = 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
    return hash & 0x7fffffff;
  }

  bool get _supportsScheduling {
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  String get _languageCode {
    final locale = PlatformDispatcher.instance.locale;
    return locale.languageCode.isEmpty ? 'zh' : locale.languageCode;
  }
}
