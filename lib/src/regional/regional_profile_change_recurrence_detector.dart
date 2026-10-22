/// `RegionalProfileChangeDetector`が地域プロフィールの内容変化を検知
/// した結果が、単発ではなく確認のたびに繰り返し検出され続けているかを
/// 判定する純関数。`RegionalProfileChangeDetector`自体は直近1回分の
/// キャッシュと最新プロフィールの比較のみを見るため、繰り返しの発生
/// 自体は見ない。実際の再確認案内の表示方法の見直しはアプリ側の責務と
/// する。
class RegionalProfileChangeRecurrenceDetector {
  const RegionalProfileChangeRecurrenceDetector({this.recurrenceThreshold = 3})
      : assert(recurrenceThreshold > 0);

  /// 連続してこの回数以上変化が検出されたら繰り返しとみなす。
  final int recurrenceThreshold;

  /// [consecutiveChangeCount]（直近から連続して地域プロフィールの変化が
  /// 検出された回数）が[recurrenceThreshold]以上であれば、繰り返し
  /// 検出されている状態と判定する。
  bool isRecurring(int consecutiveChangeCount) {
    return consecutiveChangeCount >= recurrenceThreshold;
  }
}
