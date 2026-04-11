# Tech Stack

## Recommended Stack

- Flutter stable
- Dart 3
- `flutter_riverpod` for state management
- `go_router` for navigation
- `drift` with SQLite for structured local storage
- `shared_preferences` for lightweight app settings
- `flutter_local_notifications` for local reminders
- `timezone` for safe reminder scheduling
- `workmanager` only for background repair, sync, and housekeeping

Later additions:

- `firebase_auth`
- `cloud_firestore`
- `firebase_messaging`
- `crashlytics` or equivalent

## Why This Stack

### Flutter

- one codebase for Android and iOS later
- fast UI iteration
- enough ecosystem support for a reminder app

### Riverpod

- testable
- explicit dependencies
- less hidden magic than some alternatives

### Drift

- stronger schema safety than key-value stores
- good fit for filtering by date, list, completion, and repeat state
- supports migrations and typed queries

### flutter_local_notifications

- standard choice for local notification scheduling in Flutter
- enough control for reminder-centric products

## Not Recommended For V1

- `Hive` as the main task store
  Too weak for complex querying and migrations.

- `GetX`
  Fast to start, but weaker long-term structure for a growing codebase.

- `BLoC` by default
  Good pattern, but heavier than needed for this app size.

- remote-first architecture
  It adds too much sync complexity before core UX is proven.

## Package Baseline

Suggested initial dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.1
  go_router: ^14.2.0
  drift: ^2.20.0
  sqlite3_flutter_libs: ^0.5.24
  path_provider: ^2.1.4
  path: ^1.9.0
  shared_preferences: ^2.3.2
  flutter_local_notifications: ^17.2.2
  timezone: ^0.9.4
  workmanager: ^0.5.2
  intl: ^0.19.0
  uuid: ^4.5.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.12
  drift_dev: ^2.20.1
  custom_lint: ^0.6.7
  riverpod_lint: ^2.3.13
```

Versions should be checked again when the project is scaffolded.

## Project Conventions

- feature-first folder layout
- repository pattern between UI and persistence
- immutable view models
- one source of truth in local database
- explicit reminder scheduling service

## First Platform Target

Ship Android first, but avoid architecture decisions that block iOS later.
