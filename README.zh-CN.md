# Flutter Todo Reminder

[English](README.md) | [简体中文](README.zh-CN.md)

这个目录现在包含的是一个 Flutter 待办提醒应用的规划文档和项目基线实现，产品方向参考 Microsoft To Do。

当前范围：

- 面向移动端的任务与提醒应用
- 客户端框架使用 Flutter
- MVP 采用本地优先架构
- 第一优先发布平台是 Android
- iOS 与云同步放到后续阶段

文档索引：

- `PRD.md`：产品范围与 MVP 规则
- `TECH_STACK.md`：推荐技术栈与依赖选择
- `ARCHITECTURE.md`：模块结构与数据流
- `DATA_MODEL.md`：实体与表结构设计
- `NOTIFICATION_STRATEGY.md`：提醒与调度规则
- `ROADMAP.md`：阶段性路线图
- `DEV_SETUP.md`：本地开发环境与初始化步骤
- `DECISIONS.md`：已确认与待确认的技术决策
- `IMPLEMENTATION_PLAN.md`：当前锁定的 V1 默认规则与执行顺序

建议的下一步：

1. 以 `IMPLEMENTATION_PLAN.md` 作为当前执行基线。
2. 继续完成 Phase 1 的应用基础设施。
3. 在添加同步前，先把本地 MVP 做完整。

CI 基线：

- GitHub Actions 工作流：`.github/workflows/flutter_ci.yml`
- 检查内容：`flutter pub get`、`dart run build_runner build --delete-conflicting-outputs`、`flutter analyze`、`flutter test`
- 因为项目使用了 `sqlite3` 的 system hook，所以 Ubuntu runner 会安装 `libsqlite3-dev`

Release 基线：

- GitHub Actions 工作流：`.github/workflows/android_release.yml`
- 触发方式：推送形如 `v0.1.0` 的 tag，或者在 GitHub Actions 页面手动触发
- 产物：Android release APK；如果是 tag 触发，还会自动挂到 GitHub Release
- 签名策略：如果 GitHub Secrets 中配置了 Android keystore，就用正式签名；如果没有，就回退到 debug keystore，方便内部测试

建议配置的 GitHub Secrets：

- `ANDROID_KEYSTORE_BASE64`
- `ANDROID_KEYSTORE_PASSWORD`
- `ANDROID_KEY_ALIAS`
- `ANDROID_KEY_PASSWORD`

如何发一个 release：

```bash
git tag v0.1.0
git push origin v0.1.0
```

补充说明：

- 当前 Android application ID 是 `io.github.jiangdengke.flutter_todo_reminder`
- debug keystore 回退适合内部测试，不适合正式发布到 Google Play

如果你要在当前目录重新初始化 Flutter 工程，可以使用：

```bash
cd /home/jdk/code/flutter_todo_reminder
flutter create --platforms=android,ios .
```

重新初始化后，保留这些文档，并在其基础上继续扩展应用代码。
