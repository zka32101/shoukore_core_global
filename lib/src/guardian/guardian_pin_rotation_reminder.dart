/// 保護者ゲートの認証情報（PIN等、アプリ側が独自に追加する方式を含む）を
/// 長期間変更していない場合、セキュリティ上のローテーションを促すべきかを
/// 判定する純関数。`GuardianGate`自体の認証ロジックは変更せず、最終更新
/// 時刻からの経過日数のみを見る。実際のローテーション促進UI・PIN変更
/// フローはアプリ側の責務とする。
class GuardianPinRotationReminder {
  const GuardianPinRotationReminder({this.rotationInterval = const Duration(days: 180)});

  /// この期間変更がなければローテーションを促す。
  final Duration rotationInterval;

  /// [lastChangedAt]（認証情報の最終変更時刻）から[now]までの経過が
  /// [rotationInterval]以上であれば、ローテーションを促すべきと判定する。
  /// 一度も変更記録がない場合（`null`）は常に促す。
  bool shouldRemind({required DateTime? lastChangedAt, required DateTime now}) {
    if (lastChangedAt == null) return true;
    return now.difference(lastChangedAt) >= rotationInterval;
  }
}
