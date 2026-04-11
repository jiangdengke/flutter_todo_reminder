import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_destinations.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final current = AppDestination.values[navigationShell.currentIndex];

    return LayoutBuilder(
      builder: (context, constraints) {
        final useRail = constraints.maxWidth >= 900;

        return Scaffold(
          appBar: AppBar(
            title: Text(current.label),
            actions: [
              IconButton(
                onPressed: () => context.push('/settings'),
                icon: const Icon(Icons.settings_outlined),
                tooltip: 'Settings',
              ),
            ],
          ),
          body: useRail
              ? Row(
                  children: [
                    NavigationRail(
                      selectedIndex: navigationShell.currentIndex,
                      onDestinationSelected: (index) {
                        navigationShell.goBranch(
                          index,
                          initialLocation:
                              index == navigationShell.currentIndex,
                        );
                      },
                      labelType: NavigationRailLabelType.all,
                      destinations: AppDestination.values.map((destination) {
                        return NavigationRailDestination(
                          icon: Icon(destination.icon),
                          label: Text(destination.label),
                        );
                      }).toList(),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(child: navigationShell),
                  ],
                )
              : navigationShell,
          bottomNavigationBar: useRail
              ? null
              : NavigationBar(
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: (index) {
                    navigationShell.goBranch(
                      index,
                      initialLocation: index == navigationShell.currentIndex,
                    );
                  },
                  destinations: AppDestination.values.map((destination) {
                    return NavigationDestination(
                      icon: Icon(destination.icon),
                      label: destination.label,
                    );
                  }).toList(),
                ),
        );
      },
    );
  }
}
