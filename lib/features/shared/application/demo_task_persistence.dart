import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/localization/app_locale.dart';
import '../presentation/demo_task_data.dart';

final demoTaskPersistenceProvider = Provider<DemoTaskPersistence>((ref) {
  return const DemoTaskPersistence();
});

class DemoTaskPersistence {
  const DemoTaskPersistence();

  static const _storageKey = 'demo_tasks_v1';

  Future<List<DemoTask>?> load() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final raw = preferences.getString(_storageKey);
      if (raw == null || raw.isEmpty) {
        return null;
      }

      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return null;
      }

      return decoded
          .whereType<Map>()
          .map((item) => _taskFromJson(Map<String, dynamic>.from(item)))
          .toList(growable: false);
    } on MissingPluginException {
      return null;
    } on FormatException {
      return null;
    }
  }

  Future<void> save(List<DemoTask> tasks) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final raw = jsonEncode(tasks.map(_taskToJson).toList(growable: false));
      await preferences.setString(_storageKey, raw);
    } on MissingPluginException {
      return;
    }
  }

  Map<String, dynamic> _taskToJson(DemoTask task) {
    return <String, dynamic>{
      'id': task.id,
      'title': _localizedTextToJson(task.title),
      'note': _localizedTextToJson(task.note),
      'list': task.list.name,
      'dueLabel': _localizedTextToJson(task.dueLabel),
      'reminderLabel': task.reminderLabel,
      'energyLabel': _localizedTextToJson(task.energyLabel),
      'durationLabel': _localizedTextToJson(task.durationLabel),
      'accent': task.accent.toARGB32(),
      'bucket': task.bucket.name,
      'plannedFor': task.plannedFor?.toIso8601String(),
      'isImportant': task.isImportant,
      'isDone': task.isDone,
      'inMyDay': task.inMyDay,
      'steps': task.steps.map(_stepToJson).toList(growable: false),
    };
  }

  DemoTask _taskFromJson(Map<String, dynamic> json) {
    return DemoTask(
      id: json['id'] as String,
      title: _localizedTextFromJson(Map<String, dynamic>.from(json['title'])),
      note: _localizedTextFromJson(Map<String, dynamic>.from(json['note'])),
      list: DemoTaskListKey.values.byName(json['list'] as String),
      dueLabel: _localizedTextFromJson(
        Map<String, dynamic>.from(json['dueLabel']),
      ),
      reminderLabel: json['reminderLabel'] as String?,
      energyLabel: _localizedTextFromJson(
        Map<String, dynamic>.from(json['energyLabel']),
      ),
      durationLabel: _localizedTextFromJson(
        Map<String, dynamic>.from(json['durationLabel']),
      ),
      accent: Color(json['accent'] as int),
      bucket: DemoScheduleBucket.values.byName(json['bucket'] as String),
      plannedFor: json['plannedFor'] == null
          ? null
          : DateTime.parse(json['plannedFor'] as String),
      isImportant: json['isImportant'] as bool? ?? false,
      isDone: json['isDone'] as bool? ?? false,
      inMyDay: json['inMyDay'] as bool? ?? false,
      steps: (json['steps'] as List? ?? const [])
          .whereType<Map>()
          .map((item) => _stepFromJson(Map<String, dynamic>.from(item)))
          .toList(growable: false),
    );
  }

  Map<String, dynamic> _localizedTextToJson(LocalizedText text) {
    return <String, dynamic>{'zh': text.zh, 'en': text.en};
  }

  LocalizedText _localizedTextFromJson(Map<String, dynamic> json) {
    return LocalizedText(
      zh: json['zh'] as String? ?? '',
      en: json['en'] as String? ?? '',
    );
  }

  Map<String, dynamic> _stepToJson(DemoTaskStep step) {
    return <String, dynamic>{
      'title': _localizedTextToJson(step.title),
      'isDone': step.isDone,
    };
  }

  DemoTaskStep _stepFromJson(Map<String, dynamic> json) {
    return DemoTaskStep(
      title: _localizedTextFromJson(Map<String, dynamic>.from(json['title'])),
      isDone: json['isDone'] as bool? ?? false,
    );
  }
}
