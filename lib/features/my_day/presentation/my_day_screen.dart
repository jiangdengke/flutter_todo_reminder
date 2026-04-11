import 'package:flutter/material.dart';

import '../../shared/presentation/feature_placeholder_view.dart';

class MyDayScreen extends StatelessWidget {
  const MyDayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderView(
      eyebrow: 'Today',
      title: 'Focus on what matters today.',
      description:
          'My Day is a curated daily view. It resets automatically by date, but the task records themselves stay unchanged.',
      accent: Color(0xFFE07A28),
      highlights: [
        'Manual add to My Day',
        'Derived by local date',
        'No midnight cleanup job',
      ],
      cards: [
        PlaceholderCardData(
          icon: Icons.sunny,
          title: 'Curated, not auto-noisy',
          body:
              'Tasks only appear here when the user explicitly adds them, which keeps the view lightweight.',
        ),
        PlaceholderCardData(
          icon: Icons.restart_alt_rounded,
          title: 'Simple reset behavior',
          body:
              'Using myDayOn == localToday makes the daily reset predictable and avoids extra background work.',
        ),
      ],
    );
  }
}
