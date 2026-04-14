import 'package:flutter/material.dart';

import '../../../app/localization/app_locale.dart';
import '../../../app/theme/noir_palette.dart';

enum DemoScheduleBucket { today, tomorrow, week, later }

enum DemoTaskListKey { studio, planning, home, personal }

enum DemoPriorityBucket { urgentImportant, important, urgent, routine }

extension DemoTaskListKeyX on DemoTaskListKey {
  String label(BuildContext context) => switch (this) {
    DemoTaskListKey.studio => context.tr('工作室', 'Studio'),
    DemoTaskListKey.planning => context.tr('规划', 'Planning'),
    DemoTaskListKey.home => context.tr('家庭', 'Home'),
    DemoTaskListKey.personal => context.tr('个人', 'Personal'),
  };

  String description(BuildContext context) => switch (this) {
    DemoTaskListKey.studio => context.tr('发布与产品打磨', 'Shipping and polish'),
    DemoTaskListKey.planning => context.tr('回顾与整理', 'Reviews and cleanup'),
    DemoTaskListKey.home => context.tr('家务与维修', 'Home errands'),
    DemoTaskListKey.personal => context.tr('个人事务与预约', 'Personal admin'),
  };
}

extension DemoPriorityBucketX on DemoPriorityBucket {
  String label(BuildContext context) => switch (this) {
    DemoPriorityBucket.urgentImportant => context.tr(
      '重要且紧急',
      'Urgent & important',
    ),
    DemoPriorityBucket.important => context.tr('重要不紧急', 'Important'),
    DemoPriorityBucket.urgent => context.tr('紧急不重要', 'Urgent'),
    DemoPriorityBucket.routine => context.tr('常规事项', 'Routine'),
  };

  String description(BuildContext context) => switch (this) {
    DemoPriorityBucket.urgentImportant => context.tr(
      '优先马上处理',
      'Handle these first',
    ),
    DemoPriorityBucket.important => context.tr(
      '值得提前安排',
      'Plan these intentionally',
    ),
    DemoPriorityBucket.urgent => context.tr(
      '尽快清掉的小事',
      'Quick items to clear soon',
    ),
    DemoPriorityBucket.routine => context.tr(
      '按空档推进即可',
      'Move these when you have room',
    ),
  };

  Color get accent => switch (this) {
    DemoPriorityBucket.urgentImportant => NoirPalette.magenta,
    DemoPriorityBucket.important => NoirPalette.electricBlue,
    DemoPriorityBucket.urgent => NoirPalette.cyan,
    DemoPriorityBucket.routine => NoirPalette.mint,
  };
}

class DemoTaskStep {
  const DemoTaskStep({required this.title, this.isDone = false});

  final LocalizedText title;
  final bool isDone;

  String titleOf(BuildContext context) => title.resolve(context);

  DemoTaskStep copyWith({LocalizedText? title, bool? isDone}) {
    return DemoTaskStep(
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }
}

class DemoTask {
  const DemoTask({
    required this.id,
    required this.title,
    required this.note,
    required this.list,
    required this.dueLabel,
    required this.energyLabel,
    required this.durationLabel,
    required this.accent,
    required this.bucket,
    this.reminderLabel,
    this.plannedFor,
    this.isImportant = false,
    this.isDone = false,
    this.inMyDay = false,
    this.steps = const [],
  });

  final String id;
  final LocalizedText title;
  final LocalizedText note;
  final DemoTaskListKey list;
  final LocalizedText dueLabel;
  final String? reminderLabel;
  final LocalizedText energyLabel;
  final LocalizedText durationLabel;
  final Color accent;
  final DemoScheduleBucket bucket;
  final DateTime? plannedFor;
  final bool isImportant;
  final bool isDone;
  final bool inMyDay;
  final List<DemoTaskStep> steps;

  String titleOf(BuildContext context) => title.resolve(context);

  String noteOf(BuildContext context) => note.resolve(context);

  String listNameOf(BuildContext context) => list.label(context);

  String dueLabelOf(BuildContext context) {
    if (plannedFor != null) {
      return context.formatShortDate(plannedFor!);
    }
    return dueLabel.resolve(context);
  }

  String energyLabelOf(BuildContext context) => energyLabel.resolve(context);

  String durationLabelOf(BuildContext context) =>
      durationLabel.resolve(context);

  bool get isUrgent =>
      bucket == DemoScheduleBucket.today ||
      bucket == DemoScheduleBucket.tomorrow;

  DemoPriorityBucket get priorityBucket {
    if (isImportant && isUrgent) {
      return DemoPriorityBucket.urgentImportant;
    }
    if (isImportant) {
      return DemoPriorityBucket.important;
    }
    if (isUrgent) {
      return DemoPriorityBucket.urgent;
    }
    return DemoPriorityBucket.routine;
  }

  int get completedSteps {
    var completed = 0;
    for (final step in steps) {
      if (step.isDone) {
        completed += 1;
      }
    }
    return completed;
  }

  int get totalSteps => steps.length;

  double get progress {
    if (isDone) {
      return 1;
    }
    if (steps.isEmpty) {
      return 0;
    }
    return completedSteps / totalSteps;
  }

  DemoTask copyWith({
    LocalizedText? title,
    LocalizedText? note,
    DemoTaskListKey? list,
    LocalizedText? dueLabel,
    String? reminderLabel,
    bool clearReminder = false,
    LocalizedText? energyLabel,
    LocalizedText? durationLabel,
    Color? accent,
    DemoScheduleBucket? bucket,
    DateTime? plannedFor,
    bool clearPlannedFor = false,
    bool? isImportant,
    bool? isDone,
    bool? inMyDay,
    List<DemoTaskStep>? steps,
  }) {
    return DemoTask(
      id: id,
      title: title ?? this.title,
      note: note ?? this.note,
      list: list ?? this.list,
      dueLabel: dueLabel ?? this.dueLabel,
      reminderLabel: clearReminder
          ? null
          : (reminderLabel ?? this.reminderLabel),
      energyLabel: energyLabel ?? this.energyLabel,
      durationLabel: durationLabel ?? this.durationLabel,
      accent: accent ?? this.accent,
      bucket: bucket ?? this.bucket,
      plannedFor: clearPlannedFor ? null : (plannedFor ?? this.plannedFor),
      isImportant: isImportant ?? this.isImportant,
      isDone: isDone ?? this.isDone,
      inMyDay: inMyDay ?? this.inMyDay,
      steps: steps ?? this.steps,
    );
  }
}

class DemoTaskListGroup {
  const DemoTaskListGroup({required this.list, required this.tasks});

  final DemoTaskListKey list;
  final List<DemoTask> tasks;
}

class DemoTaskData {
  DemoTaskData._();

  static const List<String> _todoIds = [
    'release-cut',
    'redesign-empty-state',
    'call-electrician',
    'refill-prescription',
    'inbox-sweep',
  ];

  static const List<DemoTask> _catalog = [
    DemoTask(
      id: 'release-cut',
      title: LocalizedText(zh: '发布收尾', en: 'Wrap release'),
      note: LocalizedText(zh: '确认截图和更新说明', en: 'Check screenshots and notes'),
      list: DemoTaskListKey.studio,
      dueLabel: LocalizedText(zh: '今天', en: 'Today'),
      reminderLabel: '10:30',
      energyLabel: LocalizedText(zh: '专注', en: 'Focus'),
      durationLabel: LocalizedText(zh: '45 分钟', en: '45 min'),
      accent: NoirPalette.magenta,
      bucket: DemoScheduleBucket.today,
      isImportant: true,
      inMyDay: true,
      steps: [
        DemoTaskStep(
          title: LocalizedText(zh: '检查 Android 包', en: 'Check Android build'),
          isDone: true,
        ),
        DemoTaskStep(
          title: LocalizedText(zh: '补发布说明', en: 'Finish release notes'),
        ),
        DemoTaskStep(
          title: LocalizedText(zh: '发上线更新', en: 'Post launch update'),
        ),
      ],
    ),
    DemoTask(
      id: 'redesign-empty-state',
      title: LocalizedText(zh: '空状态改版', en: 'Refresh empty states'),
      note: LocalizedText(zh: '收紧层级和留白', en: 'Tighten hierarchy and spacing'),
      list: DemoTaskListKey.studio,
      dueLabel: LocalizedText(zh: '今天', en: 'Today'),
      reminderLabel: '13:30',
      energyLabel: LocalizedText(zh: '设计', en: 'Design'),
      durationLabel: LocalizedText(zh: '60 分钟', en: '60 min'),
      accent: NoirPalette.cyan,
      bucket: DemoScheduleBucket.today,
      isImportant: true,
      inMyDay: true,
      steps: [
        DemoTaskStep(
          title: LocalizedText(zh: '画层级草图', en: 'Sketch layout'),
          isDone: true,
        ),
        DemoTaskStep(
          title: LocalizedText(zh: '调整间距', en: 'Tune spacing'),
        ),
        DemoTaskStep(
          title: LocalizedText(zh: '检查对比度', en: 'Check contrast'),
        ),
      ],
    ),
    DemoTask(
      id: 'inbox-sweep',
      title: LocalizedText(zh: '清空收件箱', en: 'Clear inbox'),
      note: LocalizedText(
        zh: '把零散记录统一归档',
        en: 'Tidy loose notes into one place',
      ),
      list: DemoTaskListKey.planning,
      dueLabel: LocalizedText(zh: '今天', en: 'Today'),
      energyLabel: LocalizedText(zh: '轻量', en: 'Light'),
      durationLabel: LocalizedText(zh: '12 分钟', en: '12 min'),
      accent: NoirPalette.mint,
      bucket: DemoScheduleBucket.today,
      isDone: true,
      inMyDay: true,
      steps: [
        DemoTaskStep(
          title: LocalizedText(zh: '补标签', en: 'Add tags'),
          isDone: true,
        ),
        DemoTaskStep(
          title: LocalizedText(zh: '归档旧记录', en: 'Archive stale notes'),
          isDone: true,
        ),
      ],
    ),
    DemoTask(
      id: 'call-electrician',
      title: LocalizedText(zh: '约走廊灯维修', en: 'Book light repair'),
      note: LocalizedText(zh: '下班前打个电话确认', en: 'Make a quick scheduling call'),
      list: DemoTaskListKey.home,
      dueLabel: LocalizedText(zh: '今天', en: 'Today'),
      reminderLabel: '16:30',
      energyLabel: LocalizedText(zh: '电话', en: 'Call'),
      durationLabel: LocalizedText(zh: '10 分钟', en: '10 min'),
      accent: NoirPalette.electricBlue,
      bucket: DemoScheduleBucket.today,
      inMyDay: true,
    ),
    DemoTask(
      id: 'refill-prescription',
      title: LocalizedText(zh: '拿续方药', en: 'Pick up refill'),
      note: LocalizedText(zh: '顺路和买菜一起办', en: 'Bundle it with groceries'),
      list: DemoTaskListKey.personal,
      dueLabel: LocalizedText(zh: '明天', en: 'Tomorrow'),
      reminderLabel: '08:15',
      energyLabel: LocalizedText(zh: '跑腿', en: 'Errand'),
      durationLabel: LocalizedText(zh: '20 分钟', en: '20 min'),
      accent: NoirPalette.cyan,
      bucket: DemoScheduleBucket.tomorrow,
      isImportant: true,
      inMyDay: true,
    ),
    DemoTask(
      id: 'weekly-review',
      title: LocalizedText(zh: '周回顾', en: 'Weekly review'),
      note: LocalizedText(
        zh: '清收件箱并排下周',
        en: 'Clear inbox and shape next week',
      ),
      list: DemoTaskListKey.planning,
      dueLabel: LocalizedText(zh: '周五', en: 'Friday'),
      reminderLabel: '17:00',
      energyLabel: LocalizedText(zh: '复盘', en: 'Review'),
      durationLabel: LocalizedText(zh: '30 分钟', en: '30 min'),
      accent: NoirPalette.magenta,
      bucket: DemoScheduleBucket.week,
      isImportant: true,
      steps: [
        DemoTaskStep(
          title: LocalizedText(zh: '清空收件箱', en: 'Clear inbox'),
          isDone: true,
        ),
        DemoTaskStep(
          title: LocalizedText(zh: '重排项目', en: 'Re-rank projects'),
        ),
        DemoTaskStep(
          title: LocalizedText(zh: '定下下周重点', en: 'Pick next focus'),
        ),
      ],
    ),
    DemoTask(
      id: 'passport-photo',
      title: LocalizedText(zh: '预约证件照', en: 'Book passport photo'),
      note: LocalizedText(zh: '续办前先把照片搞定', en: 'Handle the photo first'),
      list: DemoTaskListKey.personal,
      dueLabel: LocalizedText(zh: '周五', en: 'Friday'),
      reminderLabel: '11:00',
      energyLabel: LocalizedText(zh: '事务', en: 'Admin'),
      durationLabel: LocalizedText(zh: '15 分钟', en: '15 min'),
      accent: NoirPalette.electricBlue,
      bucket: DemoScheduleBucket.week,
    ),
    DemoTask(
      id: 'water-plants',
      title: LocalizedText(zh: '浇阳台植物', en: 'Water plants'),
      note: LocalizedText(zh: '周日前顺手做掉', en: 'A small Sunday reset'),
      list: DemoTaskListKey.home,
      dueLabel: LocalizedText(zh: '周日', en: 'Sunday'),
      reminderLabel: '19:00',
      energyLabel: LocalizedText(zh: '整理', en: 'Reset'),
      durationLabel: LocalizedText(zh: '10 分钟', en: '10 min'),
      accent: NoirPalette.mint,
      bucket: DemoScheduleBucket.later,
    ),
  ];

  static List<DemoTask> initialTasks(DateTime now) {
    return List<DemoTask>.unmodifiable(
      _catalog.map(
        (task) => task.copyWith(plannedFor: _seedDate(task.bucket, now)),
      ),
    );
  }

  static DemoTask? taskByIdFrom(List<DemoTask> tasks, String id) {
    for (final task in tasks) {
      if (task.id == id) {
        return task;
      }
    }
    return null;
  }

  static List<DemoTask> todoTasksFrom(List<DemoTask> tasks) {
    return _selectFrom(tasks, _todoIds);
  }

  static List<DemoTask> openTodoTasksFrom(List<DemoTask> tasks) {
    return todoTasksFrom(
      tasks,
    ).where((task) => !task.isDone).toList(growable: false);
  }

  static List<DemoTask> doneTodoTasksFrom(List<DemoTask> tasks) {
    return todoTasksFrom(
      tasks,
    ).where((task) => task.isDone).toList(growable: false);
  }

  static int todoCompleteCountFrom(List<DemoTask> tasks) =>
      todoTasksFrom(tasks).where((task) => task.isDone).length;

  static int reminderCountFrom(List<DemoTask> tasks) =>
      tasks.where((task) => task.reminderLabel != null).length;

  static List<DemoTaskListGroup> taskGroupsFrom(List<DemoTask> tasks) {
    return DemoTaskListKey.values
        .map(
          (list) => DemoTaskListGroup(
            list: list,
            tasks: tasks
                .where((task) => task.list == list)
                .toList(growable: false),
          ),
        )
        .toList(growable: false);
  }

  static Map<DemoPriorityBucket, List<DemoTask>> priorityGroupsFrom(
    List<DemoTask> tasks,
  ) {
    final groups = <DemoPriorityBucket, List<DemoTask>>{
      for (final bucket in DemoPriorityBucket.values) bucket: <DemoTask>[],
    };

    final ordered = [...tasks]..sort(_compareTasks);
    for (final task in ordered) {
      groups[task.priorityBucket]!.add(task);
    }
    return groups;
  }

  static List<DemoTask> tasksForDate(List<DemoTask> tasks, DateTime date) {
    final normalized = _dateOnly(date);
    return tasks
        .where(
          (task) =>
              task.plannedFor != null && _sameDay(task.plannedFor!, normalized),
        )
        .toList(growable: false)
      ..sort(_compareTasks);
  }

  static List<DemoTask> upcomingTasks(List<DemoTask> tasks) {
    return [...tasks]..sort(_compareTasks);
  }

  static DateTime _seedDate(DemoScheduleBucket bucket, DateTime now) {
    final today = _dateOnly(now);
    return switch (bucket) {
      DemoScheduleBucket.today => today,
      DemoScheduleBucket.tomorrow => today.add(const Duration(days: 1)),
      DemoScheduleBucket.week => today.add(const Duration(days: 3)),
      DemoScheduleBucket.later => today.add(const Duration(days: 7)),
    };
  }

  static List<DemoTask> _selectFrom(List<DemoTask> source, List<String> ids) {
    final tasks = <DemoTask>[];
    for (final id in ids) {
      final task = taskByIdFrom(source, id);
      if (task != null) {
        tasks.add(task);
      }
    }
    return tasks;
  }

  static int _compareTasks(DemoTask a, DemoTask b) {
    final aDate = a.plannedFor ?? DateTime(2999);
    final bDate = b.plannedFor ?? DateTime(2999);
    final byDate = aDate.compareTo(bDate);
    if (byDate != 0) {
      return byDate;
    }
    if (a.isDone != b.isDone) {
      return a.isDone ? 1 : -1;
    }
    return a.id.compareTo(b.id);
  }

  static DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
