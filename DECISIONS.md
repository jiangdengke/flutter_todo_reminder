# Decisions

## Confirmed

- app direction: Microsoft To Do inspired
- client framework: Flutter
- first shipping target: Android
- architecture direction: local-first
- first version: single-user, no sync
- reminder trigger field: `reminderAt`
- planning field: `dueAt`

## Recommended Defaults

- state management: Riverpod
- routing: go_router
- database: Drift
- settings store: shared_preferences
- local notification layer: flutter_local_notifications
- background repair jobs: workmanager

## Locked For V1

- `My Day` is derived by `myDayOn == localToday`, so it resets automatically at local midnight without a cleanup job
- completed tasks are hidden by default in list detail, with room for a later "show completed" section
- weekly repeat rules may include weekday subsets in V1
- tags are out of scope for V1; lists plus important flag are enough
- one reminder per task in V1
- one due date per task
- custom lists only, no folders
- steps are lightweight checklist items, not full nested tasks
- local IDs use UUID strings

## Decisions To Avoid Delaying

If no stronger preference appears, keep these defaults:

- one reminder per task in V1
- one due date per task
- custom lists only, no folders
- steps are lightweight checklist items, not full nested tasks
- local IDs use UUID strings
