import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../app/bootstrap/app_bootstrap.dart';
import '../../../app/localization/app_locale.dart';
import '../../../app/theme/noir_palette.dart';
import '../../../services/notifications/notification_service.dart';
import 'demo_task_persistence.dart';
import '../presentation/demo_task_data.dart';

final demoTaskStoreProvider =
    StateNotifierProvider<DemoTaskStore, List<DemoTask>>((ref) {
      return DemoTaskStore(
        persistence: ref.watch(demoTaskPersistenceProvider),
        notificationService: ref.watch(notificationServiceProvider),
      );
    });

class DemoTaskStore extends StateNotifier<List<DemoTask>> {
  DemoTaskStore({
    required DemoTaskPersistence persistence,
    required NotificationService notificationService,
  }) : _persistence = persistence,
       _notificationService = notificationService,
       super(DemoTaskData.initialTasks(DateTime.now())) {
    unawaited(_initialize());
  }

  static const _uuid = Uuid();

  final DemoTaskPersistence _persistence;
  final NotificationService _notificationService;
  bool _initialized = false;

  void toggleDone(String id) {
    _commit([
      for (final task in state)
        if (task.id == id) task.copyWith(isDone: !task.isDone) else task,
    ]);
  }

  void scheduleTask(String id, DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    _commit([
      for (final task in state)
        if (task.id == id) task.copyWith(plannedFor: normalized) else task,
    ]);
  }

  void updateTask({
    required String id,
    required Locale locale,
    required String title,
    required String note,
    String? reminderLabel,
    bool clearReminder = false,
  }) {
    final languageCode = locale.languageCode;
    _commit([
      for (final task in state)
        if (task.id == id)
          task.copyWith(
            title: task.title.copyWith(
              zh: languageCode == 'zh' ? title : null,
              en: languageCode == 'en' ? title : null,
            ),
            note: task.note.copyWith(
              zh: languageCode == 'zh' ? note : null,
              en: languageCode == 'en' ? note : null,
            ),
            reminderLabel: clearReminder
                ? null
                : (reminderLabel ?? task.reminderLabel),
            clearReminder: clearReminder,
          )
        else
          task,
    ]);
  }

  void createTask({
    required DateTime date,
    required String title,
    required String note,
    String? reminderLabel,
  }) {
    final normalized = DateTime(date.year, date.month, date.day);
    final trimmedTitle = title.trim();
    final trimmedNote = note.trim();
    final bucket = _bucketForDate(normalized);

    final task = DemoTask(
      id: _uuid.v4(),
      title: LocalizedText(zh: trimmedTitle, en: trimmedTitle),
      note: LocalizedText(zh: trimmedNote, en: trimmedNote),
      list: DemoTaskListKey.planning,
      dueLabel: LocalizedText(zh: '', en: ''),
      reminderLabel: reminderLabel,
      durationLabel: const LocalizedText(zh: '30 分钟', en: '30 min'),
      energyLabel: const LocalizedText(zh: '处理中', en: 'In flow'),
      accent: _accentForBucket(bucket),
      bucket: bucket,
      plannedFor: normalized,
    );

    _commit([...state, task]);
  }

  DemoScheduleBucket _bucketForDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final diff = date.difference(today).inDays;

    if (diff <= 0) {
      return DemoScheduleBucket.today;
    }
    if (diff == 1) {
      return DemoScheduleBucket.tomorrow;
    }
    if (diff <= 7) {
      return DemoScheduleBucket.week;
    }
    return DemoScheduleBucket.later;
  }

  Color _accentForBucket(DemoScheduleBucket bucket) => switch (bucket) {
    DemoScheduleBucket.today => NoirPalette.cyan,
    DemoScheduleBucket.tomorrow => NoirPalette.electricBlue,
    DemoScheduleBucket.week => NoirPalette.magenta,
    DemoScheduleBucket.later => NoirPalette.mint,
  };

  Future<void> _initialize() async {
    final restored = await _persistence.load();
    if (restored != null && restored.isNotEmpty) {
      state = restored;
    } else {
      await _persistence.save(state);
    }

    _initialized = true;
    await _notificationService.syncTaskReminders(state);
  }

  void _commit(List<DemoTask> nextState) {
    state = nextState;
    if (_initialized) {
      unawaited(_persistAndSync(nextState));
    }
  }

  Future<void> _persistAndSync(List<DemoTask> tasks) async {
    await _persistence.save(tasks);
    await _notificationService.syncTaskReminders(tasks);
  }
}
