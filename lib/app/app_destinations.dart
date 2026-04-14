import 'package:flutter/material.dart';

import 'localization/app_locale.dart';
import 'theme/noir_palette.dart';

enum AppDestination { todo, planning, priority, profile }

extension AppDestinationX on AppDestination {
  String label(BuildContext context) => switch (this) {
    AppDestination.todo => context.tr('待办', 'Todo'),
    AppDestination.planning => context.tr('计划', 'Plan'),
    AppDestination.priority => context.tr('优先级', 'Priority'),
    AppDestination.profile => context.tr('我的', 'Me'),
  };

  String get route => switch (this) {
    AppDestination.todo => '/todo',
    AppDestination.planning => '/planning',
    AppDestination.priority => '/priority',
    AppDestination.profile => '/profile',
  };

  String subtitle(BuildContext context) => switch (this) {
    AppDestination.todo => context.tr(
      '查看、编辑并完成任务',
      'Review, edit, and finish tasks',
    ),
    AppDestination.planning => context.tr(
      '在日历里安排要做什么',
      'Schedule tasks on the calendar',
    ),
    AppDestination.priority => context.tr(
      '按轻重缓急拆分任务',
      'Sort tasks by urgency and importance',
    ),
    AppDestination.profile => context.tr(
      '语言与本地设置',
      'Language and local settings',
    ),
  };

  Color get accent => switch (this) {
    AppDestination.todo => NoirPalette.cyan,
    AppDestination.planning => NoirPalette.electricBlue,
    AppDestination.priority => NoirPalette.magenta,
    AppDestination.profile => NoirPalette.mint,
  };

  IconData get icon => switch (this) {
    AppDestination.todo => Icons.check_circle_outline_rounded,
    AppDestination.planning => Icons.calendar_month_outlined,
    AppDestination.priority => Icons.flag_outlined,
    AppDestination.profile => Icons.person_outline_rounded,
  };
}
