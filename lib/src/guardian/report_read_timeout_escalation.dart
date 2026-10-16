/// `ReportReadState`に記録された最終既読時刻から一定期間が過ぎても
/// 保護者がレポートを確認していない場合、通知方法をエスカレーション
/// （例: アプリ内バッジ→プッシュ通知→メール）すべきかを判定する純関数。
/// `ReportReadState`自体は既読時刻の記録・問い合わせのみを担うため、
/// 本クラスがその時刻と現在時刻の差分を見る。実際のエスカレーション先
/// 選定・送信処理はアプリ側の責務とする。
class ReportReadTimeoutEscalation {
  const ReportReadTimeoutEscalation({this.escalateAfter = const Duration(days: 3)});

  /// 最終既読からこの期間が過ぎたらエスカレーション対象とする。
  final Duration escalateAfter;

  /// [lastReadAt]（最終既読時刻、未既読は`null`）から[now]までの経過が
  /// [escalateAfter]以上であればエスカレーションすべきと判定する。
  bool shouldEscalate({required DateTime? lastReadAt, required DateTime now}) {
    if (lastReadAt == null) return false;
    return now.difference(lastReadAt) >= escalateAfter;
  }
}
