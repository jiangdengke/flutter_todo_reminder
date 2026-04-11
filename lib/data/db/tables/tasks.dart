import 'package:drift/drift.dart';

import 'task_lists.dart';

@DataClassName('TaskEntry')
@TableIndex(name: 'tasks_status_idx', columns: {#status})
@TableIndex(name: 'tasks_list_status_idx', columns: {#listId, #status})
@TableIndex(name: 'tasks_due_at_idx', columns: {#dueAt})
@TableIndex(name: 'tasks_reminder_at_idx', columns: {#reminderAt})
@TableIndex(
  name: 'tasks_important_status_idx',
  columns: {#isImportant, #status},
)
@TableIndex(name: 'tasks_updated_at_idx', columns: {#updatedAt})
class Tasks extends Table {
  TextColumn get id => text()();

  TextColumn get listId => text().nullable().references(
    TaskLists,
    #id,
    onDelete: KeyAction.setNull,
  )();

  TextColumn get title => text().withLength(min: 1, max: 200)();

  TextColumn get note => text().nullable()();

  TextColumn get status => text()
      .withLength(min: 1, max: 32)
      .withDefault(const Constant('active'))();

  BoolColumn get isImportant => boolean().withDefault(const Constant(false))();

  DateTimeColumn get dueAt => dateTime().nullable()();

  DateTimeColumn get reminderAt => dateTime().nullable()();

  TextColumn get repeatRule => text().nullable()();

  TextColumn get myDayOn => text().nullable()();

  DateTimeColumn get completedAt => dateTime().nullable()();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
