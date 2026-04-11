# Flutter Todo Reminder

This directory holds the planning docs for a Flutter app inspired by Microsoft To Do.

The current scope is:

- Mobile-first task and reminder app
- Flutter as the client framework
- Local-first MVP
- Android as the first shipping platform
- iOS and cloud sync as later phases

Document map:

- `PRD.md`: product scope and MVP rules
- `TECH_STACK.md`: recommended stack and package choices
- `ARCHITECTURE.md`: module layout and data flow
- `DATA_MODEL.md`: entities and schema design
- `NOTIFICATION_STRATEGY.md`: reminder and scheduling rules
- `ROADMAP.md`: phased delivery plan
- `DEV_SETUP.md`: local setup and bootstrap steps
- `DECISIONS.md`: confirmed and pending technical decisions
- `IMPLEMENTATION_PLAN.md`: locked V1 defaults and execution order

Suggested next steps:

1. Use `IMPLEMENTATION_PLAN.md` as the execution baseline.
2. Finish Phase 1 app bootstrap in this directory.
3. Implement the local-only MVP before adding sync.

CI baseline:

- GitHub Actions workflow: `.github/workflows/flutter_ci.yml`
- Checks: `flutter pub get`, `dart run build_runner build --delete-conflicting-outputs`, `flutter analyze`, `flutter test`
- Ubuntu runner installs `libsqlite3-dev` because this project uses the system SQLite hook configuration

When you are ready to scaffold code in this same directory:

```bash
cd /home/jdk/code/flutter_todo_reminder
flutter create --platforms=android,ios .
```

After scaffolding, keep these docs and add app code around them.
