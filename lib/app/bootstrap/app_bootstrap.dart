import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database_bootstrap.dart';
import '../../services/notifications/notification_service.dart';
import '../../services/timezone/timezone_service.dart';
import '../localization/app_locale.dart';

final appBootstrapperProvider = Provider<AppBootstrapper>((ref) {
  return AppBootstrapper(
    databaseBootstrap: const DatabaseBootstrap(),
    notificationService: NotificationService(),
    timezoneService: const TimezoneService(),
  );
});

final appStartupProvider = FutureProvider<AppStartupState>((ref) async {
  return ref.read(appBootstrapperProvider).run();
});

class AppBootstrapper {
  AppBootstrapper({
    required this.databaseBootstrap,
    required this.notificationService,
    required this.timezoneService,
  });

  final DatabaseBootstrap databaseBootstrap;
  final NotificationService notificationService;
  final TimezoneService timezoneService;

  Future<AppStartupState> run() async {
    await timezoneService.initialize();
    final databasePath = await databaseBootstrap.prepare();
    final notificationPermission = await notificationService.initialize();

    return AppStartupState(
      databasePath: databasePath,
      notificationPermission: notificationPermission,
    );
  }
}

class AppStartupState {
  const AppStartupState({
    required this.databasePath,
    required this.notificationPermission,
  });

  final String databasePath;
  final NotificationPermissionState notificationPermission;
}

extension NotificationPermissionStateX on NotificationPermissionState {
  String labelOf(BuildContext context) => switch (this) {
    NotificationPermissionState.unknown => context.tr('未知', 'Unknown'),
    NotificationPermissionState.granted => context.tr('已允许', 'Granted'),
    NotificationPermissionState.denied => context.tr('已拒绝', 'Denied'),
    NotificationPermissionState.notSupported => context.tr(
      '当前平台不支持',
      'Not supported',
    ),
  };
}
