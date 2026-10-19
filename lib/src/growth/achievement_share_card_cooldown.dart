/// 達成共有カードの直前の共有時刻。
class AchievementShareCardCooldownState {
  const AchievementShareCardCooldownState({this.lastSharedAt});

  static const initial = AchievementShareCardCooldownState();

  final DateTime? lastSharedAt;
}

/// 達成共有カードが短時間に連続して共有されすぎないよう、クールダウン中
/// かを判定する純関数。`AchievementShareCardBuilder`は共有カードの表示用
/// データを組み立てるのみで共有の頻度は見ない。`AchievementProximityHint`
/// は達成間近の状態を知らせるものであり、共有行動の頻度制御とは無関係。
/// `AchievementUnlockClusterDetector`は複数の達成が短期間にまとまって
/// 解除されたかを見るものであり、共有行動自体は見ない。実際の共有UI・
/// ブロック表示はアプリ側の責務とする。
class AchievementShareCardCooldown {
  const AchievementShareCardCooldown({
    this.cooldown = const Duration(minutes: 5),
  });

  /// 共有後に次の共有を許可するまでの間隔。
  final Duration cooldown;

  /// [state]（直前の共有時刻）を基準に、[now]時点で共有が許可されるかを
  /// 判定する。まだ一度も共有していなければ常に許可する。
  bool canShare(AchievementShareCardCooldownState state, DateTime now) {
    final lastSharedAt = state.lastSharedAt;
    if (lastSharedAt == null) return true;
    return now.difference(lastSharedAt) >= cooldown;
  }

  /// 共有を実行した直後に呼ぶ。次回の[canShare]判定に使う新しい状態を
  /// 返す。
  AchievementShareCardCooldownState recordShare(DateTime now) {
    return AchievementShareCardCooldownState(lastSharedAt: now);
  }
}
