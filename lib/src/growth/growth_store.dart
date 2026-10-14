import 'growth_snapshot.dart';

/// growth状態（コイン残高・デイリーミッション進捗・累計正答数）の保存先を
/// 抽象化する。`ProgressStore`と同様、既定実装は端末内drift(SQLite)。
abstract class GrowthStore {
  Future<GrowthSnapshot> load();

  Future<void> save(GrowthSnapshot snapshot);

  /// 保護者からのデータ削除要求（LGPD/ECA Digital対応）に応じて全記録を消去する。
  Future<void> clearAll();
}
