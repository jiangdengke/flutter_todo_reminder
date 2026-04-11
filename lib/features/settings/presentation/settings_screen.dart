import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/bootstrap/app_bootstrap.dart';
import '../../shared/presentation/feature_placeholder_view.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startup = ref.watch(appStartupProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: FeaturePlaceholderView(
        eyebrow: 'Runtime',
        title: 'Bootstrap status is wired into the app shell.',
        description:
            'This page exposes early startup state so the local-first foundation is visible while core features are built.',
        accent: const Color(0xFF4E5F78),
        highlights: const [
          'Notification bootstrap',
          'Database path ready',
          'Platform state visible',
        ],
        cards: [
          PlaceholderCardData(
            icon: Icons.notifications_active_outlined,
            title: 'Notification permission',
            body: startup == null
                ? 'Loading startup state...'
                : startup.notificationPermission.label,
          ),
          PlaceholderCardData(
            icon: Icons.storage_outlined,
            title: 'Database file',
            body: startup?.databasePath ?? 'Loading database path...',
          ),
        ],
      ),
    );
  }
}
