import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_reminder/app/app.dart';
import 'package:flutter_todo_reminder/app/bootstrap/app_bootstrap.dart';
import 'package:flutter_todo_reminder/services/notifications/notification_service.dart';

void main() {
  testWidgets('默认进入中文待办页，并可切换到英文', (tester) async {
    tester.view.physicalSize = const Size(1400, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appStartupProvider.overrideWith((ref) async {
            return const AppStartupState(
              databasePath: '/tmp/todo_reminder.sqlite',
              notificationPermission: NotificationPermissionState.unknown,
            );
          }),
        ],
        child: const TodoReminderApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('待执行'), findsOneWidget);
    expect(find.text('待办'), findsWidgets);

    await tester.tap(find.text('我的').first);
    await tester.pumpAndSettle();

    expect(find.text('界面语言'), findsOneWidget);
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.text('Me'), findsWidgets);
    expect(find.text('App language'), findsOneWidget);
  });
}
