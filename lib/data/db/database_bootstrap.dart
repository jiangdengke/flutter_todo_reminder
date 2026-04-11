import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DatabaseBootstrap {
  const DatabaseBootstrap();

  static const fileName = 'todo_reminder.sqlite';

  Future<String> prepare() async {
    final directory = await getApplicationSupportDirectory();
    await Directory(directory.path).create(recursive: true);
    return p.join(directory.path, fileName);
  }
}
