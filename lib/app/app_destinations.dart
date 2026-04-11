import 'package:flutter/material.dart';

enum AppDestination { myDay, important, planned, tasks }

extension AppDestinationX on AppDestination {
  String get label => switch (this) {
    AppDestination.myDay => 'My Day',
    AppDestination.important => 'Important',
    AppDestination.planned => 'Planned',
    AppDestination.tasks => 'Tasks',
  };

  String get route => switch (this) {
    AppDestination.myDay => '/my-day',
    AppDestination.important => '/important',
    AppDestination.planned => '/planned',
    AppDestination.tasks => '/tasks',
  };

  IconData get icon => switch (this) {
    AppDestination.myDay => Icons.wb_sunny_outlined,
    AppDestination.important => Icons.star_outline_rounded,
    AppDestination.planned => Icons.calendar_today_outlined,
    AppDestination.tasks => Icons.checklist_rtl_rounded,
  };
}
