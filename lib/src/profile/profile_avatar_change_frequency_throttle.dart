/// アバター変更履歴の状態（直近の変更回数と、その計測を開始した時刻）。
class ProfileAvatarChangeState {
  const ProfileAvatarChangeState({
    this.changeCountInWindow = 0,
    this.windowStartedAt,
  });

  static const initial = ProfileAvatarChangeState();

  final int changeCountInWindow;
  final DateTime? windowStartedAt;
}

/// 短時間に何度もアバター変更が繰り返されている場合、一定時間は再度の
/// 変更を制限すべきかを判定する純関数。`ProfileAvatarRotationSuggester`は
/// 成長段階が進んだ際に変更を提案するだけで、変更操作自体の頻度は見ない。
/// `ProfileSwitchCooldown`はプロフィール切替自体の連続頻度を制限するもの
/// であり、アバター変更の頻度は見ない。実際の変更UI・ブロック表示は
/// アプリ側の責務とする。
class ProfileAvatarChangeFrequencyThrottle {
  const ProfileAvatarChangeFrequencyThrottle({
    this.window = const Duration(minutes: 1),
    this.maxChangesInWindow = 3,
  }) : assert(maxChangesInWindow > 0);

  /// 変更回数を数える時間枠。
  final Duration window;

  /// この時間枠内に許可する最大変更回数。
  final int maxChangesInWindow;

  /// [state]（直前のアバター変更履歴）を基準に、[now]時点で変更が許可
  /// されるかを判定する。時間枠が過ぎていれば常に許可する。
  bool canChange(ProfileAvatarChangeState state, DateTime now) {
    final windowStartedAt = state.windowStartedAt;
    if (windowStartedAt == null) return true;
    if (now.difference(windowStartedAt) >= window) return true;
    return state.changeCountInWindow < maxChangesInWindow;
  }

  /// アバター変更を実行した直後に呼ぶ。次回の[canChange]判定に使う新しい
  /// 状態を返す。時間枠が過ぎていれば回数をリセットし、新しい時間枠を
  /// 開始する。
  ProfileAvatarChangeState recordChange(ProfileAvatarChangeState state, DateTime now) {
    final windowStartedAt = state.windowStartedAt;
    if (windowStartedAt == null || now.difference(windowStartedAt) >= window) {
      return ProfileAvatarChangeState(changeCountInWindow: 1, windowStartedAt: now);
    }
    return ProfileAvatarChangeState(
      changeCountInWindow: state.changeCountInWindow + 1,
      windowStartedAt: windowStartedAt,
    );
  }
}
