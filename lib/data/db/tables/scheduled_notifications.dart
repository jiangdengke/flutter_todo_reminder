import 'package:drift/drift.dart';

import 'tasks.dart';

@DataClassName('ScheduledNotificationEntry')
@TableIndex(name: 'scheduled_notifications_task_idx', columns: {#taskId})
class ScheduledNotifications extends Table {
  TextColumn get id => text()();

  TextColumn get taskId =>
      text().references(Tasks, #id, onDelete: KeyAction.cascade)();

  IntColumn get platformRequestId => integer().unique()();

  DateTimeColumn get scheduledFor => dateTime()();

  TextColumn get status => text().withLength(min: 1, max: 32)();

  TextColumn get lastError => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
