import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_locale.dart';
import '../../../app/theme/noir_palette.dart';
import '../../shared/application/demo_task_store.dart';
import '../../shared/presentation/demo_task_data.dart';
import '../../shared/presentation/task_ui.dart';

class ImportantScreen extends ConsumerWidget {
  const ImportantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(demoTaskStoreProvider);
    final groups = DemoTaskData.priorityGroupsFrom(tasks);
    final urgentImportant =
        groups[DemoPriorityBucket.urgentImportant] ?? const [];
    final important = groups[DemoPriorityBucket.important] ?? const [];
    final urgent = groups[DemoPriorityBucket.urgent] ?? const [];
    final routine = groups[DemoPriorityBucket.routine] ?? const [];

    return PlannerScrollView(
      children: [
        HeroBanner(
          eyebrow: context.tr('任务分层', 'Task priority'),
          title: context.tr('优先级', 'Priority'),
          description: context.tr(
            '按紧急度和重要度来分，不再只看一个“重要”列表。',
            'Split work by urgency and importance instead of using a single starred list.',
          ),
          accent: NoirPalette.magenta,
          tags: [
            MetaChip(
              icon: Icons.priority_high_rounded,
              label: context.tr(
                '${urgentImportant.length} 项先做',
                '${urgentImportant.length} first',
              ),
            ),
            MetaChip(
              icon: Icons.flag_outlined,
              label: context.tr(
                '${important.length} 项要安排',
                '${important.length} plan',
              ),
            ),
            MetaChip(
              icon: Icons.bolt_outlined,
              label: context.tr(
                '${urgent.length} 项快处理',
                '${urgent.length} quick',
              ),
            ),
          ],
          aside: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProgressDonut(
                progress: tasks.isEmpty
                    ? 0
                    : urgentImportant.length / tasks.length,
                value: '${urgentImportant.length}',
                label: context.tr('最高优先', 'top tier'),
                tint: NoirPalette.magenta,
              ),
              const SizedBox(height: 14),
              Text(
                context.tr(
                  '四个分区会比单一“重要”更容易决策。',
                  'Four buckets make prioritizing easier than a single important list.',
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.86),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _PrioritySection(
          bucket: DemoPriorityBucket.urgentImportant,
          tasks: urgentImportant,
        ),
        _PrioritySection(
          bucket: DemoPriorityBucket.important,
          tasks: important,
        ),
        _PrioritySection(bucket: DemoPriorityBucket.urgent, tasks: urgent),
        _PrioritySection(bucket: DemoPriorityBucket.routine, tasks: routine),
      ],
    );
  }
}

class _PrioritySection extends ConsumerWidget {
  const _PrioritySection({required this.bucket, required this.tasks});

  final DemoPriorityBucket bucket;
  final List<DemoTask> tasks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: PaperPanel(
        tint: bucket.accent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeading(
              title: bucket.label(context),
              subtitle: bucket.description(context),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: bucket.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  context.tr('${tasks.length} 项', '${tasks.length} items'),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: bucket.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            if (tasks.isEmpty)
              Text(
                context.tr(
                  '这一组目前没有任务。',
                  'There are no tasks in this group yet.',
                ),
              )
            else
              ...tasks.map(
                (task) => TaskPreviewCard(
                  task: task,
                  compact: true,
                  onTap: () => context.push('/task/${task.id}'),
                  footer: Align(
                    alignment: Alignment.centerLeft,
                    child: FilledButton.tonalIcon(
                      onPressed: () => ref
                          .read(demoTaskStoreProvider.notifier)
                          .toggleDone(task.id),
                      icon: Icon(
                        task.isDone ? Icons.undo_rounded : Icons.check_rounded,
                      ),
                      label: Text(
                        context.tr(
                          task.isDone ? '恢复' : '完成',
                          task.isDone ? 'Undo' : 'Complete',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
