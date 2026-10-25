/// `DeviceLocaleSuggestionIgnoredDetector`が検知した端末ロケール提案の
/// 連続無視状態が解消し、連続して提案が受け入れられるようになったと
/// 判定され続けているかを判定する純関数。
/// `DeviceLocaleSuggestionIgnoredDetector`自体は連続無視の有無のみを
/// 見る単発判定であり、解消の確認自体は見ない。実際の提案方法の見直し
/// ・表示頻度の調整はアプリ側の責務とする。
class DeviceLocaleSuggestionIgnoredRecoveryDetector {
  const DeviceLocaleSuggestionIgnoredRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  /// [consecutiveAcceptedCount]（直近から連続して提案どおりのロケール
  /// が選ばれた回数）が[recoveryThreshold]以上であれば、解消状態と
  /// 判定する。
  bool isRecovered(int consecutiveAcceptedCount) {
    return consecutiveAcceptedCount >= recoveryThreshold;
  }
}
