import '../models/models.dart';

/// 学習記録の保存先を抽象化する。既定実装は端末内drift(SQLite)。
/// Firestore等外部サービスに密結合しない。
abstract class ProgressStore {
  Future<void> recordAttempt(Attempt attempt);

  Future<Mastery> getMastery(String unitId);

  Future<List<Mastery>> getAllMastery();

  Future<List<Attempt>> getAttempts(String unitId, {int? limit});

  /// 保護者からのデータ削除要求（LGPD/ECA Digital対応）に応じて全記録を消去する。
  Future<void> clearAll();
}
