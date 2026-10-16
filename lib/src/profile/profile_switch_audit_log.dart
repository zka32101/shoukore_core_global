/// 保護者が後から「いつ・どのプロフィールに切り替わったか」を確認できる
/// ように、プロフィール切り替えの発生を記録すべきかを判定する純関数。
/// `ActiveProfileGuard`（保存直前の不整合検知）とは異なり、正常な切り替え
/// 操作そのものを記録対象にするかどうかを判定するだけで、実際の記録の
/// 保存・一覧表示はアプリ側の責務とする。
class ProfileSwitchAuditLog {
  const ProfileSwitchAuditLog();

  /// [fromProfileId]と[toProfileId]が異なる場合、切り替えが発生したとして
  /// 記録すべきと判定する。初回選択（[fromProfileId]が`null`）の場合は
  /// 記録不要とする。
  bool shouldRecord({required String? fromProfileId, required String toProfileId}) {
    if (fromProfileId == null) return false;
    return fromProfileId != toProfileId;
  }
}
