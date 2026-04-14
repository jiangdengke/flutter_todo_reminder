import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/app_destinations.dart';
import '../../../app/localization/app_locale.dart';
import '../../../app/theme/noir_palette.dart';
import '../../shared/presentation/task_ui.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final current = AppDestination.values[navigationShell.currentIndex];
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final useRail = constraints.maxWidth >= 920;

        return Scaffold(
          extendBody: !useRail,
          body: PlannerBackdrop(
            tint: current.accent,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                    child: PaperPanel(
                      tint: current.accent,
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.tr('任务面板', 'Task board'),
                                  style: textTheme.titleLarge?.copyWith(
                                    color: NoirPalette.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  current.subtitle(context),
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: NoirPalette.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: NoirPalette.backgroundRaised.withValues(
                                alpha: 0.72,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: current.accent.withValues(alpha: 0.48),
                              ),
                              boxShadow: NoirPalette.glow(
                                current.accent,
                                blur: 16,
                                spread: -10,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 9,
                                  height: 9,
                                  decoration: BoxDecoration(
                                    color: current.accent,
                                    shape: BoxShape.circle,
                                    boxShadow: NoirPalette.glow(
                                      current.accent,
                                      blur: 10,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  current.label(context),
                                  style: textTheme.labelLarge?.copyWith(
                                    color: NoirPalette.textPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: useRail
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: Row(
                              children: [
                                _RailCard(
                                  current: current,
                                  navigationShell: navigationShell,
                                ),
                                const SizedBox(width: 20),
                                Expanded(child: navigationShell),
                              ],
                            ),
                          )
                        : navigationShell,
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: useRail
              ? null
              : SafeArea(
                  top: false,
                  minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: NoirPalette.panelGlass,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: current.accent.withValues(alpha: 0.38),
                      ),
                      boxShadow: [
                        ...NoirPalette.glow(
                          current.accent,
                          blur: 22,
                          spread: -12,
                        ),
                      ],
                    ),
                    child: NavigationBar(
                      selectedIndex: navigationShell.currentIndex,
                      onDestinationSelected: (index) {
                        navigationShell.goBranch(
                          index,
                          initialLocation:
                              index == navigationShell.currentIndex,
                        );
                      },
                      destinations: AppDestination.values.map((destination) {
                        return NavigationDestination(
                          icon: Icon(destination.icon),
                          label: destination.label(context),
                        );
                      }).toList(),
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class _RailCard extends StatelessWidget {
  const _RailCard({required this.current, required this.navigationShell});

  final AppDestination current;
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 116,
      child: PaperPanel(
        tint: current.accent,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: current.accent.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: current.accent.withValues(alpha: 0.44),
                ),
                boxShadow: NoirPalette.glow(
                  current.accent,
                  blur: 16,
                  spread: -10,
                ),
              ),
              child: Icon(
                Icons.widgets_outlined,
                color: current.accent,
                size: 28,
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: NavigationRail(
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: (index) {
                  navigationShell.goBranch(
                    index,
                    initialLocation: index == navigationShell.currentIndex,
                  );
                },
                labelType: NavigationRailLabelType.all,
                destinations: AppDestination.values.map((destination) {
                  return NavigationRailDestination(
                    icon: Icon(destination.icon),
                    label: Text(destination.label(context)),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
