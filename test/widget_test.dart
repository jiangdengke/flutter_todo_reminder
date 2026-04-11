import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_reminder/app/app.dart';
import 'package:flutter_todo_reminder/app/bootstrap/app_bootstrap.dart';
import 'package:flutter_todo_reminder/services/notifications/notification_service.dart';

void main() {
  testWidgets('boots into the My Day shell', (tester) async {
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

    expect(find.text('My Day'), findsWidgets);
    expect(find.text('Focus on what matters today.'), findsOneWidget);
  });
}
