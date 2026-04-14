import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/localization/app_locale.dart';
import '../../../app/theme/noir_palette.dart';
import '../../shared/application/demo_task_store.dart';
import '../../shared/presentation/demo_task_data.dart';
import '../../shared/presentation/task_editor_dialog.dart';
import '../../shared/presentation/task_ui.dart';

class PlannedScreen extends ConsumerStatefulWidget {
  const PlannedScreen({super.key});

  @override
  ConsumerState<PlannedScreen> createState() => _PlannedScreenState();
}

class _PlannedScreenState extends ConsumerState<PlannedScreen> {
  late DateTime _selectedDate;
  late DateTime _visibleMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _visibleMonth = DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(demoTaskStoreProvider);
    final selectedTasks = DemoTaskData.tasksForDate(tasks, _selectedDate);
    final openSelectedTasks = selectedTasks
        .where((task) => !task.isDone)
        .toList(growable: false);
    final candidates = DemoTaskData.upcomingTasks(tasks)
        .where((task) => !task.isDone)
        .where((task) => !_sameDay(task.plannedFor, _selectedDate))
        .toList(growable: false);
    final calendarTasks = _tasksForVisibleCalendar(tasks, _visibleMonth);
    final now = DateTime.now();
    final minMonth = DateTime(now.year - 1, now.month);
    final maxMonth = DateTime(now.year + 1, now.month);

    return PlannerScrollView(
      children: [
        HeroBanner(
          eyebrow: context.tr('日历安排', 'Calendar planning'),
          title: context.tr('计划', 'Plan'),
          description: context.tr('按日期安排任务。', 'Plan tasks by date.'),
          accent: NoirPalette.electricBlue,
          tags: [
            MetaChip(
              icon: Icons.calendar_today_outlined,
              label: context.formatShortDate(_selectedDate),
            ),
            MetaChip(
              icon: Icons.checklist_outlined,
              label: context.tr(
                '${openSelectedTasks.length} 项待做',
                '${openSelectedTasks.length} open',
              ),
            ),
            MetaChip(
              icon: Icons.move_down_outlined,
              label: context.tr(
                '${candidates.length} 项可调整',
                '${candidates.length} movable',
              ),
            ),
          ],
          aside: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProgressDonut(
                progress: selectedTasks.isEmpty
                    ? 0
                    : selectedTasks.where((task) => task.isDone).length /
                          selectedTasks.length,
                value: '${selectedTasks.length}',
                label: context.tr('当天任务', 'scheduled'),
                tint: NoirPalette.electricBlue,
              ),
              const SizedBox(height: 14),
              Text(
                context.tr(
                  '下方任务点“安排到这天”就会移动到所选日期。',
                  'Use “Plan for this day” below to move a task onto the selected date.',
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.86),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final calendar = PaperPanel(
              tint: NoirPalette.electricBlue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.tr('选择日期', 'Choose a date'),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: () =>
                            _showCreateTaskDialog(context, ref, _selectedDate),
                        icon: const Icon(Icons.add_rounded),
                        label: Text(context.tr('新增待办', 'Add task')),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _TaskMonthCalendar(
                    visibleMonth: _visibleMonth,
                    selectedDate: _selectedDate,
                    tasksByDate: calendarTasks,
                    minMonth: minMonth,
                    maxMonth: maxMonth,
                    onSelectDate: (date) {
                      setState(() {
                        _selectedDate = date;
                        _visibleMonth = DateTime(date.year, date.month);
                      });
                    },
                    onChangeMonth: (delta) {
                      final nextMonth = DateTime(
                        _visibleMonth.year,
                        _visibleMonth.month + delta,
                      );
                      final daysInMonth = DateUtils.getDaysInMonth(
                        nextMonth.year,
                        nextMonth.month,
                      );
                      final nextDay = _selectedDate.day > daysInMonth
                          ? daysInMonth
                          : _selectedDate.day;

                      setState(() {
                        _visibleMonth = DateTime(
                          nextMonth.year,
                          nextMonth.month,
                        );
                        _selectedDate = DateTime(
                          nextMonth.year,
                          nextMonth.month,
                          nextDay,
                        );
                      });
                    },
                  ),
                ],
              ),
            );

            final summary = PaperPanel(
              tint: NoirPalette.cyan,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('当天概览', 'Selected day'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 14),
                  MetricCard(
                    label: context.tr('待做任务', 'Open tasks'),
                    value: context.tr(
                      '${openSelectedTasks.length} 项',
                      '${openSelectedTasks.length} items',
                    ),
                    icon: Icons.event_available_outlined,
                    tint: NoirPalette.electricBlue,
                  ),
                  const SizedBox(height: 12),
                  MetricCard(
                    label: context.tr('总任务数', 'Total tasks'),
                    value: context.tr(
                      '${selectedTasks.length} 项',
                      '${selectedTasks.length} items',
                    ),
                    icon: Icons.assignment_outlined,
                    tint: NoirPalette.cyan,
                  ),
                ],
              ),
            );

            if (constraints.maxWidth < 920) {
              return Column(
                children: [calendar, const SizedBox(height: 12), summary],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: calendar),
                const SizedBox(width: 12),
                Expanded(flex: 4, child: summary),
              ],
            );
          },
        ),
        const SizedBox(height: 28),
        SectionHeading(
          title: context.tr('已安排', 'Scheduled'),
          subtitle: context.tr('所选日期任务', 'Tasks for the selected date'),
          trailing: FilledButton.icon(
            onPressed: () => _showCreateTaskDialog(context, ref, _selectedDate),
            icon: const Icon(Icons.add_rounded),
            label: Text(context.tr('新增待办', 'Add task')),
          ),
        ),
        const SizedBox(height: 14),
        if (selectedTasks.isEmpty)
          PaperPanel(
            tint: NoirPalette.electricBlue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr(
                    '这一天还没有任务。',
                    'No tasks are planned for this day yet.',
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () =>
                      _showCreateTaskDialog(context, ref, _selectedDate),
                  icon: const Icon(Icons.add_rounded),
                  label: Text(context.tr('新增待办', 'Add task')),
                ),
              ],
            ),
          )
        else
          ...selectedTasks.map(
            (task) => TaskPreviewCard(
              task: task,
              onTap: () => context.push('/task/${task.id}'),
              footer: _PlannedTaskActions(task: task),
            ),
          ),
        const SizedBox(height: 18),
        SectionHeading(
          title: context.tr('待安排', 'Backlog'),
          subtitle: context.tr('可安排到所选日期的任务', 'Tasks available for scheduling'),
        ),
        const SizedBox(height: 14),
        ...candidates.map(
          (task) => TaskPreviewCard(
            task: task,
            compact: true,
            onTap: () => context.push('/task/${task.id}'),
            footer: Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.tonalIcon(
                onPressed: () => ref
                    .read(demoTaskStoreProvider.notifier)
                    .scheduleTask(task.id, _selectedDate),
                icon: const Icon(Icons.event_available_outlined),
                label: Text(context.tr('安排到这天', 'Plan for this day')),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

bool _sameDay(DateTime? a, DateTime b) {
  if (a == null) {
    return false;
  }
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

Map<DateTime, List<DemoTask>> _tasksForVisibleCalendar(
  List<DemoTask> tasks,
  DateTime visibleMonth,
) {
  final monthStart = DateTime(visibleMonth.year, visibleMonth.month);
  final leading = monthStart.weekday - DateTime.monday;
  final gridStart = monthStart.subtract(Duration(days: leading));
  final gridEnd = gridStart.add(const Duration(days: 41));
  final byDate = <DateTime, List<DemoTask>>{};

  for (final task in tasks) {
    final plannedFor = task.plannedFor;
    if (plannedFor == null) {
      continue;
    }

    final day = DateTime(plannedFor.year, plannedFor.month, plannedFor.day);
    if (day.isBefore(gridStart) || day.isAfter(gridEnd)) {
      continue;
    }

    byDate.putIfAbsent(day, () => <DemoTask>[]).add(task);
  }

  for (final entry in byDate.entries) {
    entry.value.sort((a, b) {
      if (a.isDone != b.isDone) {
        return a.isDone ? 1 : -1;
      }
      if (a.isImportant != b.isImportant) {
        return a.isImportant ? -1 : 1;
      }
      return a.id.compareTo(b.id);
    });
  }

  return byDate;
}

class _TaskMonthCalendar extends StatelessWidget {
  const _TaskMonthCalendar({
    required this.visibleMonth,
    required this.selectedDate,
    required this.tasksByDate,
    required this.minMonth,
    required this.maxMonth,
    required this.onSelectDate,
    required this.onChangeMonth,
  });

  final DateTime visibleMonth;
  final DateTime selectedDate;
  final Map<DateTime, List<DemoTask>> tasksByDate;
  final DateTime minMonth;
  final DateTime maxMonth;
  final ValueChanged<DateTime> onSelectDate;
  final ValueChanged<int> onChangeMonth;

  @override
  Widget build(BuildContext context) {
    final monthStart = DateTime(visibleMonth.year, visibleMonth.month);
    final gridStart = monthStart.subtract(
      Duration(days: monthStart.weekday - DateTime.monday),
    );
    final canGoPrevious = !_isBeforeMonth(visibleMonth, minMonth);
    final canGoNext = !_isAfterMonth(visibleMonth, maxMonth);

    return LayoutBuilder(
      builder: (context, constraints) {
        final cellHeight = constraints.maxWidth >= 680
            ? 96.0
            : constraints.maxWidth >= 520
            ? 84.0
            : 72.0;
        final taskPreviewCount = constraints.maxWidth >= 680 ? 2 : 1;

        return Column(
          children: [
            Row(
              children: [
                _MonthNavButton(
                  icon: Icons.chevron_left_rounded,
                  enabled: canGoPrevious,
                  onPressed: () => onChangeMonth(-1),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      _monthLabel(context, visibleMonth),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                _MonthNavButton(
                  icon: Icons.chevron_right_rounded,
                  enabled: canGoNext,
                  onPressed: () => onChangeMonth(1),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: _weekdayLabels(context)
                  .map(
                    (label) => Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            label,
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: NoirPalette.textSecondary,
                                  letterSpacing: 0.8,
                                ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
            for (var week = 0; week < 6; week++) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var day = 0; day < 7; day++)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: _CalendarDayCell(
                          date: gridStart.add(Duration(days: week * 7 + day)),
                          visibleMonth: visibleMonth,
                          selectedDate: selectedDate,
                          tasks:
                              tasksByDate[gridStart.add(
                                Duration(days: week * 7 + day),
                              )] ??
                              const [],
                          height: cellHeight,
                          taskPreviewCount: taskPreviewCount,
                          onTap: onSelectDate,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}

class _MonthNavButton extends StatelessWidget {
  const _MonthNavButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: enabled ? onPressed : null,
      style: IconButton.styleFrom(
        backgroundColor: NoirPalette.backgroundRaised.withValues(alpha: 0.7),
        foregroundColor: NoirPalette.textPrimary,
        disabledForegroundColor: NoirPalette.textMuted,
        disabledBackgroundColor: NoirPalette.backgroundRaised.withValues(
          alpha: 0.35,
        ),
        side: BorderSide(
          color: enabled
              ? NoirPalette.electricBlue.withValues(alpha: 0.45)
              : NoirPalette.border.withValues(alpha: 0.5),
        ),
      ),
      icon: Icon(icon),
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({
    required this.date,
    required this.visibleMonth,
    required this.selectedDate,
    required this.tasks,
    required this.height,
    required this.taskPreviewCount,
    required this.onTap,
  });

  final DateTime date;
  final DateTime visibleMonth;
  final DateTime selectedDate;
  final List<DemoTask> tasks;
  final double height;
  final int taskPreviewCount;
  final ValueChanged<DateTime> onTap;

  @override
  Widget build(BuildContext context) {
    final isCurrentMonth = date.month == visibleMonth.month;
    final isSelected = _sameDay(date, selectedDate);
    final today = DateTime.now();
    final isToday = _sameDay(date, today);
    final textTheme = Theme.of(context).textTheme;
    final previewTasks = isCurrentMonth
        ? tasks.take(taskPreviewCount).toList(growable: false)
        : const <DemoTask>[];
    final remainingCount = isCurrentMonth && tasks.length > taskPreviewCount
        ? tasks.length - taskPreviewCount
        : 0;

    final borderColor = isSelected
        ? NoirPalette.cyan
        : isToday
        ? NoirPalette.magenta.withValues(alpha: 0.6)
        : isCurrentMonth
        ? NoirPalette.border.withValues(alpha: 0.9)
        : NoirPalette.border.withValues(alpha: 0.45);
    final fillColor = isSelected
        ? NoirPalette.electricBlue.withValues(alpha: 0.22)
        : isToday
        ? NoirPalette.magenta.withValues(alpha: 0.10)
        : NoirPalette.backgroundRaised.withValues(
            alpha: isCurrentMonth ? 0.75 : 0.28,
          );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(date),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: height,
          padding: const EdgeInsets.fromLTRB(8, 7, 8, 6),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
            boxShadow: isSelected
                ? NoirPalette.glow(NoirPalette.cyan, blur: 16, spread: -10)
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '${date.day}',
                    style: textTheme.labelLarge?.copyWith(
                      color: isCurrentMonth
                          ? NoirPalette.textPrimary
                          : NoirPalette.textMuted,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w700,
                    ),
                  ),
                  if (isToday) ...[
                    const SizedBox(width: 4),
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: NoirPalette.magenta,
                        shape: BoxShape.circle,
                        boxShadow: NoirPalette.glow(
                          NoirPalette.magenta,
                          blur: 8,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 5),
              Expanded(
                child: !isCurrentMonth || tasks.isEmpty
                    ? const SizedBox.shrink()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final task in previewTasks)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: Text(
                                task.titleOf(context),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodySmall?.copyWith(
                                  fontSize: 10.5,
                                  height: 1.1,
                                  color: task.isDone
                                      ? NoirPalette.textMuted
                                      : task.accent,
                                  decoration: task.isDone
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                            ),
                          if (remainingCount > 0)
                            Text(
                              context.tr(
                                '+$remainingCount 项',
                                '+$remainingCount',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodySmall?.copyWith(
                                fontSize: 10,
                                color: NoirPalette.textSecondary,
                              ),
                            ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<String> _weekdayLabels(BuildContext context) => context.isZh
    ? const ['一', '二', '三', '四', '五', '六', '日']
    : const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

String _monthLabel(BuildContext context, DateTime month) {
  if (context.isZh) {
    return '${month.year}年${month.month}月';
  }

  return DateFormat('MMMM yyyy', 'en').format(month);
}

bool _isBeforeMonth(DateTime current, DateTime minMonth) {
  final previous = DateTime(current.year, current.month - 1);
  return previous.isBefore(DateTime(minMonth.year, minMonth.month));
}

bool _isAfterMonth(DateTime current, DateTime maxMonth) {
  final next = DateTime(current.year, current.month + 1);
  return next.isAfter(DateTime(maxMonth.year, maxMonth.month));
}

class _PlannedTaskActions extends ConsumerWidget {
  const _PlannedTaskActions({required this.task});

  final DemoTask task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        FilledButton.tonalIcon(
          onPressed: () =>
              ref.read(demoTaskStoreProvider.notifier).toggleDone(task.id),
          icon: Icon(task.isDone ? Icons.undo_rounded : Icons.check_rounded),
          label: Text(
            context.tr(
              task.isDone ? '恢复' : '完成',
              task.isDone ? 'Undo' : 'Complete',
            ),
          ),
        ),
        OutlinedButton.icon(
          onPressed: () => _showEditTaskDialog(context, ref, task),
          icon: const Icon(Icons.edit_outlined),
          label: Text(context.tr('编辑', 'Edit')),
        ),
      ],
    );
  }
}

Future<void> _showCreateTaskDialog(
  BuildContext context,
  WidgetRef ref,
  DateTime selectedDate,
) async {
  final result = await showTaskEditorDialog(
    context: context,
    dialogTitle: context.tr('新增待办', 'Add task'),
    confirmLabel: context.tr('保存', 'Save'),
  );

  if (!context.mounted || result == null || result.title.isEmpty) {
    return;
  }

  ref
      .read(demoTaskStoreProvider.notifier)
      .createTask(
        date: selectedDate,
        title: result.title,
        note: result.note,
        reminderLabel: result.reminderLabel,
      );
}

Future<void> _showEditTaskDialog(
  BuildContext context,
  WidgetRef ref,
  DemoTask task,
) async {
  final result = await showTaskEditorDialog(
    context: context,
    dialogTitle: context.tr('编辑任务', 'Edit task'),
    confirmLabel: context.tr('保存', 'Save'),
    initialTitle: task.titleOf(context),
    initialNote: task.noteOf(context),
    initialReminderLabel: task.reminderLabel,
  );

  if (!context.mounted || result == null || result.title.isEmpty) {
    return;
  }

  final locale = Localizations.localeOf(context);
  ref
      .read(demoTaskStoreProvider.notifier)
      .updateTask(
        id: task.id,
        locale: locale,
        title: result.title,
        note: result.note,
        reminderLabel: result.reminderLabel,
        clearReminder: result.reminderLabel == null,
      );
}
