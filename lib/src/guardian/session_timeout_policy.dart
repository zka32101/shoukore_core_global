/// 一定時間操作がない場合に、アプリをロック状態（保護者ゲート等の再確認が
/// 必要な状態）に戻すべきかどうかを判定する純関数。共有端末で前の利用者が
/// ログアウトし忘れたまま放置された場合の意図しない継続利用を防ぐ。
/// `GuardianGate`（計算チャレンジ自体）とは独立した、操作無反応ベースの
/// 制限であり、実際のロック画面表示・入力監視はアプリ側の責務とする。
class SessionTimeoutPolicy {
  const SessionTimeoutPolicy({this.timeout = const Duration(minutes: 5)});

  /// 最後の操作からこの時間が経過すると、ロック状態に戻すべきと判定する。
  final Duration timeout;

  /// [lastInteractionAt]（最後に操作があった時刻）から[now]までの経過時間が
  /// [timeout]を超えている場合に`true`を返す。
  bool shouldLock(DateTime lastInteractionAt, DateTime now) {
    return now.difference(lastInteractionAt) > timeout;
  }

  /// [lastInteractionAt]からロックされるまでの残り時間を返す。既にロックすべき
  /// 場合は[Duration.zero]を返す。
  Duration remainingUntilLock(DateTime lastInteractionAt, DateTime now) {
    if (shouldLock(lastInteractionAt, now)) return Duration.zero;
    return lastInteractionAt.add(timeout).difference(now);
  }
}
