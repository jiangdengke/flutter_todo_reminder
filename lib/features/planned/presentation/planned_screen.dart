import 'package:flutter/material.dart';

import '../../shared/presentation/feature_placeholder_view.dart';

class PlannedScreen extends StatelessWidget {
  const PlannedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderView(
      eyebrow: 'Planning',
      title: 'Planned organizes work by due date.',
      description:
          'Due dates stay separate from reminders so planning views remain clear even when a task has no notification.',
      accent: Color(0xFF2E6DA4),
      highlights: [
        'Due date grouping',
        'Reminder is separate',
        'Ready for repeat rules',
      ],
      cards: [
        PlaceholderCardData(
          icon: Icons.calendar_month_outlined,
          title: 'Planning-first data model',
          body:
              'Planned is driven by dueAt, while notifications are driven by reminderAt. The two fields stay independent.',
        ),
        PlaceholderCardData(
          icon: Icons.schedule_send_outlined,
          title: 'Repeat-aware roadmap',
          body:
              'Once recurring tasks land, the planned view can show materialized future instances without mutating history.',
        ),
      ],
    );
  }
}
