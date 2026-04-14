import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'bootstrap/app_bootstrap.dart';
import '../features/important/presentation/important_screen.dart';
import '../features/my_day/presentation/my_day_screen.dart';
import '../features/planned/presentation/planned_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/shell/presentation/app_shell.dart';
import '../features/task_detail/presentation/task_detail_screen.dart';
import 'app_destinations.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final notificationService = ref.watch(notificationServiceProvider);

  return GoRouter(
    initialLocation: AppDestination.todo.route,
    refreshListenable: notificationService,
    redirect: (context, state) {
      final route = notificationService.consumePendingRoute();
      if (route == null || state.uri.path == route) {
        return null;
      }
      return route;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppDestination.todo.route,
                builder: (context, state) => const MyDayScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppDestination.planning.route,
                builder: (context, state) => const PlannedScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppDestination.priority.route,
                builder: (context, state) => const ImportantScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppDestination.profile.route,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        redirect: (context, state) => AppDestination.profile.route,
      ),
      GoRoute(
        path: '/task/:taskId',
        builder: (context, state) {
          final taskId = state.pathParameters['taskId'] ?? 'unknown';
          return TaskDetailScreen(taskId: taskId);
        },
      ),
    ],
  );
});
