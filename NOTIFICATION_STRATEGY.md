# Notification Strategy

## Goal

Reminders are the most failure-sensitive part of this app. Design around reliability, not just convenience.

## Product Rule

- `dueAt` does not notify by itself
- `reminderAt` is the notification trigger
- if the user wants both, store both

## Scheduling Strategy

Use `flutter_local_notifications` as the scheduling entry point.

For every task write:

1. validate the reminder timestamp
2. cancel any previous notification for that task
3. schedule a new local notification if `reminderAt` exists and the task is active
4. persist the platform request ID in `scheduled_notifications`

## Repair Strategy

Rebuild pending reminders when any of these happen:

- app cold start
- device reboot
- timezone change
- app update or migration affecting reminders

This is the only safe way to avoid silent drift.

## Android Constraints

### Android 13+

- notification permission must be requested at runtime

### Android 14+

- exact alarm behavior is stricter
- user education and fallback behavior must be part of the UX

## Recommended UX Flow

1. user enables first reminder
2. app explains why notification permission is required
3. app requests notification permission
4. if exact scheduling support needs extra user action, explain it in plain language
5. if denied, keep the task but show that reminder precision may be degraded

## Timezone Rules

- store timestamps in UTC in the database
- convert to local timezone for display
- schedule using timezone-aware values
- reschedule on timezone change

## Repeating Tasks

When a repeating task is completed:

1. cancel the current reminder
2. compute the next occurrence from the repeat rule
3. create or materialize the next task instance
4. schedule a new notification if the next instance has a reminder

## Failure Handling

Possible failure cases:

- permission denied
- exact alarm restrictions
- invalid past timestamp
- OS-level schedule loss after reboot or update

App behavior:

- never silently discard a reminder request
- show current reminder state in task detail
- log scheduling failures locally for debugging

## Testing Checklist

- reminder fires while app is closed
- reminder survives device reboot
- reminder survives timezone change
- editing reminder cancels old notification
- completing task cancels pending notification
- repeating task creates and schedules next occurrence correctly
