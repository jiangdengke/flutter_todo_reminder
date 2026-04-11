# Development Setup

## Prerequisites

- Flutter stable installed
- Android Studio installed
- Android SDK configured
- at least one Android emulator or real device
- Xcode only if you want iOS later

## Verify Toolchain

```bash
flutter --version
flutter doctor -v
```

## Scaffold In This Directory

```bash
cd /home/jdk/code/flutter_todo_reminder
flutter create --platforms=android,ios .
```

## Add Dependencies

After project creation, update `pubspec.yaml` with the packages from `TECH_STACK.md`, then run:

```bash
flutter pub get
```

## Generate Drift Code

When Drift tables and DAOs are added:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Suggested Initial Milestones

1. launch an empty app shell with bottom navigation or drawer
2. integrate local database
3. implement list and task CRUD
4. implement notification permission flow
5. implement reminder scheduling

## Minimum Test Commands

```bash
flutter test
flutter analyze
```

## Real Device Checks

Do not trust the emulator alone for reminder behavior. Test on a real Android device for:

- notification permission flow
- background reminder firing
- reboot recovery
- battery optimization edge cases
