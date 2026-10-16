/// 保護者向け通知が短時間に連続して送られすぎないよう、まとめ送り
/// すべきタイミングかを判定する純関数。`GuardianDigestMuteWindow`
/// （保護者が指定するミュート期間）とは異なり、直近の送信時刻からの
/// 経過時間のみで判定する。実際の通知のまとめ・送信処理はアプリ側の
/// 責務とする。
class GuardianNotificationDigestThrottle {
  const GuardianNotificationDigestThrottle({this.minimumInterval = const Duration(hours: 1)});

  /// 直前の通知送信からこの間隔を空けるまで、次の通知はまとめる。
  final Duration minimumInterval;

  /// [lastSentAt]からの経過時間が[minimumInterval]未満であれば、
  /// 今回の通知をまとめて抑制すべきと判定する。[lastSentAt]が`null`の
  /// 場合は抑制不要（送信してよい）と判定する。
  bool shouldThrottle({required DateTime? lastSentAt, required DateTime now}) {
    if (lastSentAt == null) return false;
    return now.difference(lastSentAt) < minimumInterval;
  }
}
