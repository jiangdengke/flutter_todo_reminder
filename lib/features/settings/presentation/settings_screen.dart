import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/bootstrap/app_bootstrap.dart';
import '../../../app/localization/app_locale.dart';
import '../../../app/theme/noir_palette.dart';
import '../../shared/application/demo_task_store.dart';
import '../../shared/presentation/demo_task_data.dart';
import '../../shared/presentation/task_ui.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startup = ref.watch(appStartupProvider).valueOrNull;
    final locale = ref.watch(appLocaleProvider);
    final tasks = ref.watch(demoTaskStoreProvider);
    final doneCount = tasks.where((task) => task.isDone).length;

    return PlannerScrollView(
      children: [
        HeroBanner(
          eyebrow: context.tr('个人与设置', 'Profile & settings'),
          title: context.tr('我的', 'Me'),
          description: context.tr(
            '语言、通知和本地运行信息都在这里。',
            'Language, notifications, and local runtime details live here.',
          ),
          accent: NoirPalette.mint,
          tags: [
            MetaChip(
              icon: Icons.translate_rounded,
              label: locale.languageCode == 'zh' ? '中文' : 'English',
            ),
            MetaChip(
              icon: Icons.notifications_active_outlined,
              label:
                  startup?.notificationPermission.labelOf(context) ??
                  context.tr('加载中', 'Loading'),
            ),
            MetaChip(
              icon: Icons.done_all_rounded,
              label: context.tr('$doneCount 项已完成', '$doneCount done'),
            ),
          ],
          aside: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MetricCard(
                label: context.tr('当前语言', 'Language'),
                value: locale.languageCode == 'zh' ? '中文' : 'English',
                icon: Icons.translate_rounded,
                tint: NoirPalette.mint,
              ),
              const SizedBox(height: 12),
              MetricCard(
                label: context.tr('任务总数', 'Tasks'),
                value: context.tr('${tasks.length} 项', '${tasks.length} items'),
                icon: Icons.task_alt_rounded,
                tint: NoirPalette.electricBlue,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SectionHeading(
          title: context.tr('语言', 'Language'),
          subtitle: context.tr(
            '默认中文，可切换英文。',
            'Chinese by default, English anytime.',
          ),
        ),
        const SizedBox(height: 14),
        PaperPanel(
          tint: NoirPalette.mint,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('界面语言', 'App language'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              SegmentedButton<Locale>(
                segments: const [
                  ButtonSegment<Locale>(value: Locale('zh'), label: Text('中文')),
                  ButtonSegment<Locale>(
                    value: Locale('en'),
                    label: Text('English'),
                  ),
                ],
                selected: {locale},
                onSelectionChanged: (selection) {
                  ref.read(appLocaleProvider.notifier).state = selection.first;
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        SectionHeading(
          title: context.tr('设备状态', 'Device status'),
          subtitle: context.tr(
            '当前这台设备上的本地能力。',
            'Local capabilities on this device.',
          ),
        ),
        const SizedBox(height: 14),
        PaperPanel(
          tint: NoirPalette.mint,
          child: Column(
            children: [
              LabeledInfoRow(
                label: context.tr('通知权限', 'Notification permission'),
                value:
                    startup?.notificationPermission.labelOf(context) ??
                    context.tr('加载中', 'Loading'),
              ),
              const Divider(height: 20),
              LabeledInfoRow(
                label: context.tr('数据库文件', 'Database file'),
                value:
                    startup?.databasePath ??
                    context.tr('正在读取路径…', 'Loading database path...'),
              ),
              const Divider(height: 20),
              LabeledInfoRow(
                label: context.tr('提醒数量', 'Reminders'),
                value: context.tr(
                  '${DemoTaskData.reminderCountFrom(tasks)} 个',
                  '${DemoTaskData.reminderCountFrom(tasks)} active',
                ),
              ),
              const Divider(height: 20),
              LabeledInfoRow(
                label: context.tr('存储方式', 'Storage mode'),
                value: context.tr('仅本地 SQLite', 'Local SQLite only'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
