import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_locale.dart';
import '../../../app/theme/noir_palette.dart';
import '../../shared/application/demo_task_store.dart';
import '../../shared/presentation/demo_task_data.dart';
import '../../shared/presentation/task_editor_dialog.dart';
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
