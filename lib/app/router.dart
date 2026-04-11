import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/important/presentation/important_screen.dart';
import '../features/my_day/presentation/my_day_screen.dart';
import '../features/planned/presentation/planned_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/shell/presentation/app_shell.dart';
import '../features/task_detail/presentation/task_detail_screen.dart';
import '../features/tasks/presentation/tasks_screen.dart';
import 'app_destinations.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppDestination.myDay.route,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppDestination.myDay.route,
                builder: (context, state) => const MyDayScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppDestination.important.route,
                builder: (context, state) => const ImportantScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppDestination.planned.route,
                builder: (context, state) => const PlannedScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppDestination.tasks.route,
                builder: (context, state) => const TasksScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
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
