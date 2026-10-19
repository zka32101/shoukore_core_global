/// `GuardianGateLockout`によるロックアウトが日をまたいで繰り返し発生
/// しているかを判定する純関数。`GuardianGateLockout`自体は単発の失敗
/// 回数とロック状態の管理のみを行い、ロックアウト発生自体が繰り返され
/// ているかは見ない。`GuardianGateRapidAttemptDetector`は試行間隔の
/// 異常さのみを見るため、ロックアウトの発生回数は見ない。実際の警戒時
/// の対応（保護者への通知等）はアプリ側の責務とする。
class GuardianGateLockoutRepeatedTriggerDetector {
  const GuardianGateLockoutRepeatedTriggerDetector({this.repeatedTriggerThreshold = 3})
      : assert(repeatedTriggerThreshold > 0);

  /// 連続してこの回数以上ロックアウトが発生したら繰り返しとみなす。
  final int repeatedTriggerThreshold;

  /// [consecutiveLockoutTriggerCount]（直近から連続してロックアウトが
  /// 発生した回数）が[repeatedTriggerThreshold]以上であれば、繰り返し
  /// 発生と判定する。
  bool isRepeatedlyTriggered(int consecutiveLockoutTriggerCount) {
    return consecutiveLockoutTriggerCount >= repeatedTriggerThreshold;
  }
}
