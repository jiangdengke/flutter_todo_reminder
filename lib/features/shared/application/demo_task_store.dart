import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../app/localization/app_locale.dart';
import '../presentation/demo_task_data.dart';

final demoTaskStoreProvider =
    StateNotifierProvider<DemoTaskStore, List<DemoTask>>((ref) {
      return DemoTaskStore();
    });

class DemoTaskStore extends StateNotifier<List<DemoTask>> {
  DemoTaskStore() : super(DemoTaskData.initialTasks(DateTime.now()));

  static const _uuid = Uuid();

  void toggleDone(String id) {
    state = [
      for (final task in state)
        if (task.id == id) task.copyWith(isDone: !task.isDone) else task,
    ];
  }

  void scheduleTask(String id, DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    state = [
      for (final task in state)
        if (task.id == id) task.copyWith(plannedFor: normalized) else task,
    ];
  }

  void updateTaskText({
    required String id,
    required Locale locale,
    required String title,
    required String note,
  }) {
    final languageCode = locale.languageCode;
    state = [
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
          )
        else
          task,
    ];
  }

  void createTask({
    required DateTime date,
    required String title,
    required String note,
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
      durationLabel: const LocalizedText(zh: '30 分钟', en: '30 min'),
      energyLabel: const LocalizedText(zh: '处理中', en: 'In flow'),
      accent: _accentForBucket(bucket),
      bucket: bucket,
      plannedFor: normalized,
    );

    state = [...state, task];
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
    DemoScheduleBucket.today => const Color(0xFF46F7FF),
    DemoScheduleBucket.tomorrow => const Color(0xFF3D7BFF),
    DemoScheduleBucket.week => const Color(0xFFFF4FD8),
    DemoScheduleBucket.later => const Color(0xFF59FFC6),
  };
}
