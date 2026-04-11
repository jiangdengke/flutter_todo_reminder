# Roadmap

## Phase 0: Product Lock

Deliverables:

- freeze MVP scope
- confirm data model
- confirm notification behavior
- choose exact package set

Exit criteria:

- no unresolved core product rules for reminders and repeats

## Phase 1: Project Bootstrap

Deliverables:

- scaffold Flutter project
- set up Riverpod, routing, Drift, local notifications
- add linting and test baseline
- create app theme and shell navigation

Exit criteria:

- app boots with placeholder screens
- database opens successfully
- local notification permission flow is wired

## Phase 2: Core Task Flows

Deliverables:

- create and edit task
- task lists
- complete and uncomplete task
- task detail
- important and planned filters

Exit criteria:

- local CRUD flows are stable
- state persists after restart

## Phase 3: Reminder Reliability

Deliverables:

- schedule notifications
- cancel and reschedule on edit
- restore after restart and reboot
- reminder status indicators in UI

Exit criteria:

- reminders work in real device testing

## Phase 4: Repeat and My Day

Deliverables:

- repeat rules
- next occurrence generation
- My Day behavior
- better date grouping

Exit criteria:

- repeating tasks behave predictably

## Phase 5: Polish

Deliverables:

- search
- widgets
- onboarding
- analytics and crash reporting

Exit criteria:

- stable beta quality

## Phase 6: Sync

Deliverables:

- login
- cloud sync
- conflict strategy
- push-assisted data refresh

Exit criteria:

- two-device consistency is acceptable for beta users

## Current Recommendation

Stop at Phase 4 before adding sync. That is enough to prove whether the app is worth growing.
