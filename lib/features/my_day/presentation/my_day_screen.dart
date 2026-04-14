import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_locale.dart';
import '../../../app/theme/noir_palette.dart';
import '../../shared/application/demo_task_store.dart';
import '../../shared/presentation/demo_task_data.dart';
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
  final titleController = TextEditingController(text: task.titleOf(context));
  final noteController = TextEditingController(text: task.noteOf(context));

  final saved = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(context.tr('编辑任务', 'Edit task')),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: context.tr('标题', 'Title'),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteController,
                minLines: 2,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: context.tr('备注', 'Note'),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.tr('取消', 'Cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(context.tr('保存', 'Save')),
          ),
        ],
      );
    },
  );

  if (!context.mounted) {
    titleController.dispose();
    noteController.dispose();
    return;
  }

  if (saved == true) {
    final locale = Localizations.localeOf(context);
    ref
        .read(demoTaskStoreProvider.notifier)
        .updateTaskText(
          id: task.id,
          locale: locale,
          title: titleController.text.trim().isEmpty
              ? task.title.resolveByCode(locale.languageCode)
              : titleController.text.trim(),
          note: noteController.text.trim().isEmpty
              ? task.note.resolveByCode(locale.languageCode)
              : noteController.text.trim(),
        );
  }

  titleController.dispose();
  noteController.dispose();
}
