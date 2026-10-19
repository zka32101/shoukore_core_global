/// ニックネーム変更履歴の状態（直近の変更回数と、その計測を開始した時刻）。
class ProfileNicknameChangeState {
  const ProfileNicknameChangeState({
    this.changeCountInWindow = 0,
    this.windowStartedAt,
  });

  static const initial = ProfileNicknameChangeState();

  final int changeCountInWindow;
  final DateTime? windowStartedAt;
}

/// 短時間に何度もニックネーム変更が繰り返されている場合、一定時間は
/// 再度の変更を制限すべきかを判定する純関数。
/// `ProfileAvatarChangeFrequencyThrottle`はアバター変更の頻度のみを見る
/// ものでニックネーム変更は見ない。`ProfileSwitchCooldown`はプロフィール
/// 切替自体の連続頻度を制限するものであり、ニックネーム変更は見ない。
/// 実際の変更UI・ブロック表示はアプリ側の責務とする。
class ProfileNicknameChangeFrequencyThrottle {
  const ProfileNicknameChangeFrequencyThrottle({
    this.window = const Duration(minutes: 1),
    this.maxChangesInWindow = 3,
  }) : assert(maxChangesInWindow > 0);

  /// 変更回数を数える時間枠。
  final Duration window;

  /// この時間枠内に許可する最大変更回数。
  final int maxChangesInWindow;

  /// [state]（直前のニックネーム変更履歴）を基準に、[now]時点で変更が
  /// 許可されるかを判定する。時間枠が過ぎていれば常に許可する。
  bool canChange(ProfileNicknameChangeState state, DateTime now) {
    final windowStartedAt = state.windowStartedAt;
    if (windowStartedAt == null) return true;
    if (now.difference(windowStartedAt) >= window) return true;
    return state.changeCountInWindow < maxChangesInWindow;
  }

  /// ニックネーム変更を実行した直後に呼ぶ。次回の[canChange]判定に使う
  /// 新しい状態を返す。時間枠が過ぎていれば回数をリセットし、新しい
  /// 時間枠を開始する。
  ProfileNicknameChangeState recordChange(
    ProfileNicknameChangeState state,
    DateTime now,
  ) {
    final windowStartedAt = state.windowStartedAt;
    if (windowStartedAt == null || now.difference(windowStartedAt) >= window) {
      return ProfileNicknameChangeState(changeCountInWindow: 1, windowStartedAt: now);
    }
    return ProfileNicknameChangeState(
      changeCountInWindow: state.changeCountInWindow + 1,
      windowStartedAt: windowStartedAt,
    );
  }
}
