import 'package:flutter/material.dart';

import '../../../app/localization/app_locale.dart';

class TaskEditorResult {
  const TaskEditorResult({
    required this.title,
    required this.note,
    required this.reminderLabel,
  });

  final String title;
  final String note;
  final String? reminderLabel;
}

Future<TaskEditorResult?> showTaskEditorDialog({
  required BuildContext context,
  required String dialogTitle,
  required String confirmLabel,
  String initialTitle = '',
  String initialNote = '',
  String? initialReminderLabel,
}) async {
  final titleController = TextEditingController(text: initialTitle);
  final noteController = TextEditingController(text: initialNote);
  var reminderLabel = initialReminderLabel;

  final result = await showDialog<TaskEditorResult>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(dialogTitle),
            content: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: titleController,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: context.tr('标题', 'Title'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: noteController,
                    minLines: 2,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: context.tr('备注', 'Note'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.tr('提醒时间', 'Reminder time'),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: dialogContext,
                            initialTime:
                                _parseReminder(reminderLabel) ??
                                const TimeOfDay(hour: 9, minute: 0),
                          );
                          if (picked == null) {
                            return;
                          }
                          setState(() {
                            reminderLabel = _formatReminder(picked);
                          });
                        },
                        icon: const Icon(Icons.alarm_outlined),
                        label: Text(
                          reminderLabel ?? context.tr('设置提醒', 'Set reminder'),
                        ),
                      ),
                      if (reminderLabel != null)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              reminderLabel = null;
                            });
                          },
                          child: Text(context.tr('移除提醒', 'Remove reminder')),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(context.tr('取消', 'Cancel')),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(
                    TaskEditorResult(
                      title: titleController.text.trim(),
                      note: noteController.text.trim(),
                      reminderLabel: reminderLabel,
                    ),
                  );
                },
                child: Text(confirmLabel),
              ),
            ],
          );
        },
      );
    },
  );

  titleController.dispose();
  noteController.dispose();
  return result;
}

TimeOfDay? _parseReminder(String? label) {
  if (label == null || label.isEmpty) {
    return null;
  }

  final parts = label.split(':');
  if (parts.length != 2) {
    return null;
  }

  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) {
    return null;
  }

  return TimeOfDay(hour: hour, minute: minute);
}

String _formatReminder(TimeOfDay time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
