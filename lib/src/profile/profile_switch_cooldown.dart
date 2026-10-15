/// `ProfileStore`のアクティブプロファイル切替状態（最後に切り替えた時刻）。
class ProfileSwitchState {
  const ProfileSwitchState({this.lastSwitchedAt});

  static const initial = ProfileSwitchState();

  final DateTime? lastSwitchedAt;
}

/// 短時間に何度もプロファイル切替が行われた場合、一定時間は再度の切替を
/// 制限すべきかを判定する純関数。兄弟間での進捗確認目的の連続切替や、
/// 誤操作の連打によるちらつきを防ぐ。`ActiveProfileGuard`（切替中の
/// データ混在防止）とは独立した、切替操作自体の頻度制限であり、実際の
/// 切替UI・ブロック表示はアプリ側の責務とする。
class ProfileSwitchCooldown {
  const ProfileSwitchCooldown({this.cooldown = const Duration(seconds: 3)});

  /// 切替直後からこの時間は次の切替を制限する。
  final Duration cooldown;

  /// [state]（直前の切替状態）を基準に、[now]時点で切替が許可されるかを
  /// 判定する。まだ一度も切り替えていない場合は常に許可する。
  bool canSwitch(ProfileSwitchState state, DateTime now) {
    final lastSwitchedAt = state.lastSwitchedAt;
    if (lastSwitchedAt == null) return true;
    return now.difference(lastSwitchedAt) >= cooldown;
  }

  /// 切替を実行した直後に呼ぶ。次回の[canSwitch]判定に使う新しい状態を返す。
  ProfileSwitchState recordSwitch(DateTime now) => ProfileSwitchState(lastSwitchedAt: now);
}
