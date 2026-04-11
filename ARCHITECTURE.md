# Architecture

## High-Level Shape

Use a local-first architecture:

`UI -> Controller/Notifier -> Use Case/Service -> Repository -> Drift DB`

Notification scheduling is a side-effect service that reacts to task changes.

## App Layers

### Presentation

- screens
- widgets
- Riverpod providers
- state notifiers
- route definitions

### Domain

- entities
- use cases
- repeat calculation rules
- validation rules

### Data

- Drift tables
- DAO classes
- repository implementations
- notification persistence helpers

### Platform Services

- notification scheduler
- permission manager
- timezone sync
- app lifecycle hooks

## Suggested Folder Layout

```text
lib/
  app/
    app.dart
    router.dart
    theme/
  core/
    constants/
    errors/
    time/
    utils/
  data/
    db/
      app_database.dart
      tables/
      daos/
    repositories/
  domain/
    models/
    repositories/
    services/
    use_cases/
  features/
    inbox/
    my_day/
    important/
    planned/
    task_detail/
    task_edit/
    lists/
    settings/
  services/
    notifications/
    permissions/
    background/
```

## State Flow

Recommended flow:

1. user action enters a feature controller
2. controller validates input
3. repository writes to Drift
4. repository or domain service emits updated streams
5. notification service reschedules if reminder fields changed
6. UI rebuilds from reactive state

## Navigation

Suggested routes:

- `/`
- `/my-day`
- `/important`
- `/planned`
- `/list/:listId`
- `/task/:taskId`
- `/task/new`
- `/settings`

## Architectural Rules

- UI does not talk to the database directly
- repeat calculation logic stays outside widgets
- reminder scheduling is centralized in one service
- system lists are derived views, not duplicated storage
- local IDs should be stable UUIDs

## Sync Readiness

Even in the local MVP, keep fields and repository interfaces ready for future sync:

- `updatedAt`
- `deletedAt`
- optional remote ID
- conflict-safe write APIs
