import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../shared/presentation/feature_placeholder_view.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FeaturePlaceholderView(
      eyebrow: 'Core',
      title: 'Tasks is the base list for local CRUD.',
      description:
          'This screen is the staging ground for list management, task editing, completion state, and reminder metadata.',
      accent: const Color(0xFF3F7A57),
      highlights: const [
        'Task CRUD first',
        'One reminder per task',
        'Steps stay lightweight',
      ],
      cards: const [
        PlaceholderCardData(
          icon: Icons.edit_note_rounded,
          title: 'Task editor comes next',
          body:
              'The next implementation step is a real create and edit flow with title, note, due date, reminder, and importance.',
        ),
        PlaceholderCardData(
          icon: Icons.splitscreen_outlined,
          title: 'System views stay derived',
          body:
              'Important, Planned, and My Day stay query-driven so the local database remains the only source of truth.',
        ),
      ],
      footer: FilledButton.icon(
        onPressed: () => context.push('/task/sample-task'),
        icon: const Icon(Icons.open_in_new_rounded),
        label: const Text('Open detail placeholder'),
      ),
    );
  }
}
