import 'dart:io';

import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'progress_database.dart';

/// 端末内のアプリ用ディレクトリに `progress.sqlite` を作成して開く。
Future<ProgressDatabase> openProgressDatabase() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = p.join(dir.path, 'progress.sqlite');
  return ProgressDatabase(NativeDatabase.createInBackground(File(file)));
}
