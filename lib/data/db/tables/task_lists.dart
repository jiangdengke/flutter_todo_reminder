import 'package:drift/drift.dart';

@DataClassName('TaskListEntry')
@TableIndex(name: 'task_lists_sort_order_idx', columns: {#sortOrder})
class TaskLists extends Table {
  TextColumn get id => text()();

  TextColumn get name => text().withLength(min: 1, max: 100)();

  TextColumn get color => text().nullable()();

  TextColumn get icon => text().nullable()();

  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
