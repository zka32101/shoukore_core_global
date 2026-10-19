/// 保護者ゲートのPINローテーション後に設定された新しいPINが、過去に使用
/// したPINのいずれかと同じである再利用状態を検知する純関数。
/// `GuardianPinRotationReminder`は変更タイミングの催促のみを行い、新PIN
/// の内容は見ない。`GuardianPinWeaknessDetector`はPIN自体の強度（連番・
/// 同一数字等）のみを見るため、履歴との再利用は見ない。PINそのものは
/// 本クラスに渡さず、アプリ側でハッシュ化した値同士を比較する想定。
/// 実際の「以前使ったPINは使えません」案内の表示はアプリ側の責務とする。
class GuardianPinReuseAfterRotationDetector {
  const GuardianPinReuseAfterRotationDetector();

  /// [newPinHash]（新しく設定しようとしているPINのハッシュ値）が
  /// [previousPinHashes]（過去に使用したPINのハッシュ値の履歴）のいずれか
  /// と一致する場合に、再利用状態と判定する。
  bool isReusedPin({
    required String newPinHash,
    required List<String> previousPinHashes,
  }) {
    return previousPinHashes.contains(newPinHash);
  }
}
