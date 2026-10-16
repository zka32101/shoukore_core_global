import '../growth/daily_boundary.dart';

/// `DailyDigestBuilder`で組み立てた日次要約を、同じミッション日内に
/// 複数回送信してしまわないよう抑制すべきかを判定する純関数。
/// `DailyDigestBuilder`自体は要約の組み立てのみを担い、送信済み管理には
/// 関与しないため、本クラスが最後に送信したミッション日との比較を行う。
/// 実際の送信済み記録の保存・送信処理はアプリ側の責務とする。
class DailyDigestDuplicateSuppression {
  const DailyDigestDuplicateSuppression();

  /// [lastSentDay]（最後にダイジェストを送信したミッション日、未送信は
  /// `null`）が[targetDay]と同じミッション日であれば、既に送信済みとして
  /// 抑制すべきと判定する。
  bool shouldSuppress({
    required DateTime? lastSentDay,
    required DateTime targetDay,
    required DailyBoundary boundary,
  }) {
    if (lastSentDay == null) return false;
    return boundary.isSameMissionDay(lastSentDay, targetDay);
  }
}
