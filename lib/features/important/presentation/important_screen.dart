import 'package:flutter/material.dart';

import '../../shared/presentation/feature_placeholder_view.dart';

class ImportantScreen extends StatelessWidget {
  const ImportantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderView(
      eyebrow: 'Priority',
      title: 'Important keeps the essentials visible.',
      description:
          'This view will gather starred tasks from every list and keep high-priority work one tap away.',
      accent: Color(0xFFC6483F),
      highlights: [
        'Derived from the task flag',
        'No duplicated storage',
        'Fast local filtering',
      ],
      cards: [
        PlaceholderCardData(
          icon: Icons.star_outline_rounded,
          title: 'Single source of truth',
          body:
              'Important is a derived query on top of the tasks table, so the flag stays consistent everywhere.',
        ),
        PlaceholderCardData(
          icon: Icons.tune_rounded,
          title: 'List-aware grouping',
          body:
              'Later we can group important tasks by list, due date, or reminder state without changing the core schema.',
        ),
      ],
    );
  }
}
