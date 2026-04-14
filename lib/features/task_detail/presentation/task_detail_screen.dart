import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_locale.dart';
import '../../../app/theme/noir_palette.dart';
import '../../shared/application/demo_task_store.dart';
import '../../shared/presentation/demo_task_data.dart';
import '../../shared/presentation/task_ui.dart';

class TaskDetailScreen extends ConsumerWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(demoTaskStoreProvider);
    final task = DemoTaskData.taskByIdFrom(tasks, taskId);

    if (task == null) {
      return Scaffold(
        appBar: AppBar(title: Text(context.tr('任务', 'Task'))),
        body: PlannerBackdrop(
          tint: NoirPalette.mint,
          child: PlannerScrollView(
            children: [
              HeroBanner(
                eyebrow: context.tr('预览', 'Preview'),
                title: context.tr('没找到任务', 'Task not found'),
                description: context.tr(
                  '这个任务不在当前数据里。',
                  'This task is not in the current dataset.',
                ),
                accent: NoirPalette.mint,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('任务详情', 'Task Detail'))),
      body: PlannerBackdrop(
        tint: task.accent,
        child: PlannerScrollView(
          children: [
            HeroBanner(
              eyebrow: context.tr('任务', 'Task'),
              title: task.titleOf(context),
              description: task.noteOf(context),
              accent: task.accent,
              tags: [
                MetaChip(
                  icon: Icons.event_outlined,
                  label: task.dueLabelOf(context),
                ),
                if (task.reminderLabel != null)
                  MetaChip(
                    icon: Icons.notifications_none_rounded,
                    label: task.reminderLabel!,
                  ),
                MetaChip(
                  icon: Icons.timelapse_rounded,
                  label: task.durationLabelOf(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            PaperPanel(
              tint: NoirPalette.electricBlue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('任务信息', 'Task info'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  LabeledInfoRow(
                    label: context.tr('状态', 'Status'),
                    value: context.tr(
                      task.isDone ? '已完成' : '待处理',
                      task.isDone ? 'Done' : 'Open',
                    ),
                    valueColor: task.isDone ? NoirPalette.mint : null,
                  ),
                  const Divider(height: 20),
                  LabeledInfoRow(
                    label: context.tr('任务 ID', 'Task ID'),
                    value: task.id,
                  ),
                  const Divider(height: 20),
                  LabeledInfoRow(
                    label: context.tr('安排日期', 'Planned date'),
                    value: task.dueLabelOf(context),
                  ),
                  const Divider(height: 20),
                  LabeledInfoRow(
                    label: context.tr('提醒', 'Reminder'),
                    value: task.reminderLabel ?? context.tr('无', 'None'),
                  ),
                  const Divider(height: 20),
                  LabeledInfoRow(
                    label: context.tr('优先级', 'Priority'),
                    value: task.priorityBucket.label(context),
                    valueColor: task.accent,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            PaperPanel(
              tint: NoirPalette.mint,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('操作', 'Actions'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      FilledButton.icon(
                        onPressed: () => ref
                            .read(demoTaskStoreProvider.notifier)
                            .toggleDone(task.id),
                        icon: Icon(
                          task.isDone
                              ? Icons.undo_rounded
                              : Icons.check_rounded,
                        ),
                        label: Text(
                          context.tr(
                            task.isDone ? '恢复任务' : '完成任务',
                            task.isDone ? 'Restore task' : 'Complete task',
                          ),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _showEditDialog(context, ref, task),
                        icon: const Icon(Icons.edit_outlined),
                        label: Text(context.tr('编辑', 'Edit')),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _pickDate(context, ref, task),
                        icon: const Icon(Icons.event_outlined),
                        label: Text(context.tr('重新安排', 'Reschedule')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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

Future<void> _pickDate(
  BuildContext context,
  WidgetRef ref,
  DemoTask task,
) async {
  final initialDate = task.plannedFor ?? DateTime.now();
  final date = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(DateTime.now().year - 1),
    lastDate: DateTime(DateTime.now().year + 1),
  );

  if (!context.mounted) {
    return;
  }

  if (date != null) {
    ref.read(demoTaskStoreProvider.notifier).scheduleTask(task.id, date);
  }
}
