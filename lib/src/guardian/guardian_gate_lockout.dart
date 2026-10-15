/// `GuardianGate`の計算チャレンジに対する試行状態（失敗回数・ロックアウト中か）。
class GuardianGateLockoutState {
  const GuardianGateLockoutState({this.failureCount = 0, this.lockedUntil});

  static const initial = GuardianGateLockoutState();

  final int failureCount;
  final DateTime? lockedUntil;
}

/// `GuardianGate`の計算チャレンジに繰り返し失敗した際、一定時間ロックする
/// 純関数。子どもが総当たりで保護者ゲートを突破するのを防ぐ。状態の永続化は
/// アプリ側の責務とし、本クラスは次の状態を計算するだけの値オブジェクトを扱う。
class GuardianGateLockout {
  const GuardianGateLockout({
    this.maxAttempts = 3,
    this.lockoutDuration = const Duration(minutes: 5),
  }) : assert(maxAttempts > 0);

  final int maxAttempts;
  final Duration lockoutDuration;

  bool isLocked(GuardianGateLockoutState state, DateTime now) =>
      state.lockedUntil != null && now.isBefore(state.lockedUntil!);

  /// 誤答時に呼ぶ。[maxAttempts]回連続で誤答すると[lockoutDuration]だけロックする。
  GuardianGateLockoutState recordFailure(GuardianGateLockoutState state, DateTime now) {
    final nextCount = state.failureCount + 1;
    if (nextCount >= maxAttempts) {
      return GuardianGateLockoutState(failureCount: 0, lockedUntil: now.add(lockoutDuration));
    }
    return GuardianGateLockoutState(failureCount: nextCount, lockedUntil: state.lockedUntil);
  }

  /// 正答時に呼ぶ。失敗回数・ロックアウトをリセットする。
  GuardianGateLockoutState recordSuccess() => GuardianGateLockoutState.initial;
}
