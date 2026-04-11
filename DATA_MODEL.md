# Data Model

## Core Entities

Use explicit tables instead of a single JSON blob store.

## task_lists

Purpose:

- stores custom lists
- stores metadata for non-derived lists

Fields:

- `id`: UUID
- `name`: string
- `color`: string or nullable token
- `icon`: string or nullable token
- `isSystem`: bool
- `sortOrder`: int
- `createdAt`: datetime
- `updatedAt`: datetime

Notes:

- `My Day`, `Important`, and `Planned` should be derived views in UI logic
- `Tasks` can be treated as the default base list

## tasks

Purpose:

- stores primary task records

Fields:

- `id`: UUID
- `listId`: nullable UUID
- `title`: string
- `note`: nullable text
- `status`: enum-like string, for example `active` or `completed`
- `isImportant`: bool
- `dueAt`: nullable datetime
- `reminderAt`: nullable datetime
- `repeatRule`: nullable JSON string
- `myDayOn`: nullable date string
- `completedAt`: nullable datetime
- `sortOrder`: int
- `createdAt`: datetime
- `updatedAt`: datetime
- `deletedAt`: nullable datetime

Indexes:

- `status`
- `listId, status`
- `dueAt`
- `reminderAt`
- `isImportant, status`
- `updatedAt`

## task_steps

Purpose:

- stores checklist items attached to a task

Fields:

- `id`: UUID
- `taskId`: UUID
- `title`: string
- `isCompleted`: bool
- `sortOrder`: int
- `createdAt`: datetime
- `updatedAt`: datetime

## scheduled_notifications

Purpose:

- optional internal table to track platform notification IDs and repair scheduling

Fields:

- `id`: UUID
- `taskId`: UUID
- `platformRequestId`: int
- `scheduledFor`: datetime
- `status`: string
- `lastError`: nullable text
- `createdAt`: datetime
- `updatedAt`: datetime

## Repeat Rule Shape

Store the repeat rule as JSON in V1.

Example:

```json
{
  "type": "weekly",
  "interval": 1,
  "weekdays": [1, 3, 5],
  "endsAt": null
}
```

Rule options:

- `daily`
- `weekly`
- `monthly`
- `yearly`
- `custom`

## Derived Views

Do not store these as separate tables:

- `My Day` feed
- `Important` feed
- `Planned` feed
- `Completed` view

They should be derived from `tasks`.

## Task Lifecycle

### Active Task

- `status = active`
- `completedAt = null`
- may or may not have due date or reminder

### Completed Task

- `status = completed`
- `completedAt != null`
- pending reminder should be canceled

### Soft Deleted Task

- `deletedAt != null`
- exclude from normal queries

## Migration Expectations

Likely future schema changes:

- tags
- attachments
- recurring instance table
- remote sync metadata
- list sharing metadata
