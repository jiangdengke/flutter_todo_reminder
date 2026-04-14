import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_locale.dart';
import '../../../app/theme/noir_palette.dart';
import '../../shared/application/demo_task_store.dart';
import '../../shared/presentation/demo_task_data.dart';
import '../../shared/presentation/task_editor_dialog.dart';
import '../../shared/presentation/task_ui.dart';

class MyDayScreen extends ConsumerWidget {
  const MyDayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(demoTaskStoreProvider);
    final openTasks = DemoTaskData.openTodoTasksFrom(tasks);
    final doneTasks = DemoTaskData.doneTodoTasksFrom(tasks);
    final todayTasks = DemoTaskData.tasksForDate(
      tasks,
      DateTime.now(),
    ).where((task) => !task.isDone).length;

    return PlannerScrollView(
      children: [
        HeroBanner(
          eyebrow: context.formatMonthDay(DateTime.now()),
          title: context.tr('待办', 'Todo'),
          description: context.tr('任务查看与处理。', 'Task list and actions.'),
          accent: NoirPalette.cyan,
          tags: [
            MetaChip(
              icon: Icons.check_circle_outline_rounded,
              label: context.tr(
                '${openTasks.length} 项待做',
                '${openTasks.length} open',
              ),
            ),
            MetaChip(
              icon: Icons.calendar_today_outlined,
              label: context.tr('$todayTasks 项今天做', '$todayTasks today'),
            ),
          ],
        ),
        const SizedBox(height: 28),
        SectionHeading(
          title: context.tr('待执行', 'To do'),
          subtitle: context.tr('当前未完成任务', 'Current open tasks'),
        ),
        const SizedBox(height: 14),
        ...openTasks.map(
          (task) => TaskPreviewCard(
            task: task,
            onTap: () => context.push('/task/${task.id}'),
            footer: _TaskCardActions(task: task),
          ),
        ),
        const SizedBox(height: 18),
        SectionHeading(
          title: context.tr('已完成', 'Completed'),
          subtitle: context.tr('已完成任务', 'Completed tasks'),
        ),
        const SizedBox(height: 14),
        ...doneTasks.map(
          (task) => TaskPreviewCard(
            task: task,
            onTap: () => context.push('/task/${task.id}'),
            footer: _TaskCardActions(task: task),
          ),
        ),
      ],
    );
  }
}

class _TaskCardActions extends ConsumerWidget {
  const _TaskCardActions({required this.task});

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
          onPressed: () => _showEditDialog(context, ref, task),
          icon: const Icon(Icons.edit_outlined),
          label: Text(context.tr('编辑', 'Edit')),
        ),
      ],
    );
  }
}

Future<void> _showEditDialog(
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
