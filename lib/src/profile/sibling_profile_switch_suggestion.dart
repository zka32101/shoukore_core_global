/// 同じ端末を複数の子プロフィールで共有している場合、一定時間操作が
/// ないときに「プロフィールを切り替えますか」と提案すべきかを判定する
/// 純関数。`ProfileSwitchCooldown`（切替直後の連続切替を制限する）とは
/// 逆方向の、切替を促すロジックである。実際の提案UI・切替処理はアプリ側
/// の責務とする。
class SiblingProfileSwitchSuggestion {
  const SiblingProfileSwitchSuggestion({this.idleThreshold = const Duration(minutes: 3)});

  /// 最後の操作からこの時間が経過すると、切替を提案すべきと判定する。
  final Duration idleThreshold;

  /// 他にも切り替え可能なプロフィールが存在し（[hasOtherProfiles]）、かつ
  /// [lastInteractionAt]から[now]までの経過時間が[idleThreshold]を超えて
  /// いれば、切替を提案すべきと判定する。
  bool shouldSuggestSwitch({
    required bool hasOtherProfiles,
    required DateTime lastInteractionAt,
    required DateTime now,
  }) {
    if (!hasOtherProfiles) return false;
    return now.difference(lastInteractionAt) >= idleThreshold;
  }
}
