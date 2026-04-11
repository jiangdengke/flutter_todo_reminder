# Implementation Plan

## Purpose

Use this file as the execution baseline for the local-first MVP.

## Locked Product Defaults

- Android ships first; iOS stays buildable but is not the primary test target
- local-only MVP before any account or sync work
- one reminder per task in V1
- one due date per task
- `My Day` is a derived daily view based on `myDayOn == localToday`
- completed tasks are hidden by default in list detail
- repeat support in V1 covers daily, weekly, monthly, and custom intervals
- weekly repeat rules may include weekday subsets
- tags, folders, attachments, collaboration, and natural language input are out of scope

## Execution Order

### Phase 1

- bootstrap Flutter app shell
- install Riverpod, routing, Drift, notifications, timezone support
- create theme, router, and shell navigation
- add database and notification service bootstrap

### Phase 2

- implement lists and task CRUD
- add task detail and task edit flows
- add Important and Planned derived views

### Phase 3

- schedule, cancel, and repair reminders
- restore reminders after restart, reboot, and timezone change
- surface reminder scheduling state in the UI

### Phase 4

- implement repeat rules and next occurrence generation
- finalize `My Day` behavior and date grouping

## Immediate Backlog

1. Replace the default Flutter counter app with the app shell.
2. Set up feature-first folders and route placeholders.
3. Add the Drift database entry point and schema stubs.
4. Add notification bootstrap and reminder scheduler interfaces.
5. Wire analysis and tests so the project stays green while features are added.
