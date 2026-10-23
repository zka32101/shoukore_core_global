/// `DuplicateSyncPayloadDetector`が検知した同期キュー内のペイロード重複
/// が解消し、連続して重複なしと判定され続けているかを判定する純関数。
/// `DuplicateSyncPayloadDetector`自体は1件の候補についての単発判定で
/// あり、解消の確認自体は見ない。`DuplicateSyncPayloadRecurrenceDetector`
/// は重複が繰り返されているかを見るもので、本クラスはその逆軸（解消の
/// 確認）を見る。実際の重複除去・サーバー側への問い合わせの解除方法の
/// 見直しはアプリ側の責務とする。
class DuplicateSyncPayloadRecoveryDetector {
  const DuplicateSyncPayloadRecoveryDetector({this.recoveryThreshold = 3})
      : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonDuplicateCount) {
    return consecutiveNonDuplicateCount >= recoveryThreshold;
  }
}
