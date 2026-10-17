/// 保護者ゲートのPINが、連番（"1234"等）や同一数字の繰り返し
/// （"1111"等）のような推測されやすいパターンでないかを判定する
/// 純関数。`GuardianPinRotationReminder`（最終変更からの経過時間）
/// とは異なり、本クラスはPINの値そのものの強度のみを見る。実際の
/// 設定時の警告表示・再入力の強制はアプリ側の責務とする。
class GuardianPinWeaknessDetector {
  const GuardianPinWeaknessDetector();

  /// [pin]（数字のみの文字列）が同一数字の繰り返し、または昇順/降順の
  /// 連番であれば弱いと判定する。
  bool isWeak(String pin) {
    if (pin.length < 2) return true;

    final digits = pin.split('').map(int.parse).toList();

    final allSame = digits.every((d) => d == digits.first);
    if (allSame) return true;

    var isAscending = true;
    var isDescending = true;
    for (var i = 1; i < digits.length; i++) {
      if (digits[i] != digits[i - 1] + 1) isAscending = false;
      if (digits[i] != digits[i - 1] - 1) isDescending = false;
    }
    return isAscending || isDescending;
  }
}
