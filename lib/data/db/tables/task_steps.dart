import 'package:drift/drift.dart';

import 'tasks.dart';

@DataClassName('TaskStepEntry')
@TableIndex(name: 'task_steps_task_sort_idx', columns: {#taskId, #sortOrder})
class TaskSteps extends Table {
  TextColumn get id => text()();

  TextColumn get taskId =>
      text().references(Tasks, #id, onDelete: KeyAction.cascade)();

  TextColumn get title => text().withLength(min: 1, max: 200)();

  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
