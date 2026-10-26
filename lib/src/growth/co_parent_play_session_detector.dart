/// 保護者が一緒に参加した学習セッションかどうかを判定する純関数。
/// 親子で一緒に遊びながら学べる機能の対象判定に使う。実際の親向け
/// 参加UI・案内表示自体はアプリ側の責務とする。
class CoParentPlaySessionDetector {
  const CoParentPlaySessionDetector({
    this.minGuardianInteractionCount = 1,
  }) : assert(minGuardianInteractionCount > 0);

  /// このセッション内での保護者操作回数がこの値以上であれば、
  /// 親子で一緒に遊んだセッションとみなす。
  final int minGuardianInteractionCount;

  /// [guardianInteractionCount]（セッション内で保護者が操作した
  /// 回数）が[minGuardianInteractionCount]以上であれば、親子参加
  /// セッションと判定する。
  bool isCoParentSession(int guardianInteractionCount) {
    return guardianInteractionCount >= minGuardianInteractionCount;
  }
}
