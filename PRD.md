# Product Requirements

## Product Goal

Build a clean reminder-focused task app inspired by Microsoft To Do, but keep the first release narrow:

- fast task capture
- reliable reminders
- simple list organization
- a useful "Today" view

The app should feel lightweight, not enterprise-heavy.

## Target Users

- personal productivity users
- users who want reminders more than complex project management
- users who need an Android-first app with later cross-platform potential

## Core Product Principles

- local-first
- low-friction input
- clear task status
- reminder reliability over feature count
- no complicated collaboration in V1

## MVP Features

### Lists

- default system lists: `My Day`, `Important`, `Planned`, `Tasks`
- custom lists
- reorder custom lists

### Tasks

- create, edit, complete, delete
- title and optional note
- due date
- reminder date and time
- mark as important
- move between lists

### Steps

- add checklist-style steps under a task
- complete steps independently

### Views

- all tasks in a list
- today-focused view
- planned view by due date
- important view

### Repeats

- daily
- weekly
- monthly
- custom interval

### Notifications

- local notification at reminder time
- tap notification to open task detail
- restore reminders after reboot or timezone change

## V1 Non-Goals

- shared lists
- attachments
- natural language parsing
- desktop app
- calendar month view
- advanced analytics

## V2 Candidates

- account login
- cloud sync
- widget
- search
- tags
- smart suggestions for My Day

## Key Product Rules

### Due Date vs Reminder

- `due date` is for planning and grouping
- `reminder` is what triggers a notification
- a task may have one without the other

### Repeat Task Behavior

Use this rule in V1:

- when a repeating task is completed, create or materialize the next occurrence
- keep the completed occurrence in history

This avoids confusing state resets and makes history easier to reason about.

### My Day

- `My Day` is a user-curated daily list, not just "all due today"
- tasks can be added manually to My Day
- tasks due today can also appear in Planned

## Success Criteria For MVP

- create a task in under 5 seconds
- reminder fires at the expected time in normal conditions
- core flows work offline
- app state remains correct after app restart or device reboot
