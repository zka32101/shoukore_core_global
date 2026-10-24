/// `SyncConflictResolutionChoiceBiasDetector`が検知した同期コンフリクト
/// 解決の片側偏りが解消し、連続してバランスが取れていると判定され
/// 続けているかを判定する純関数。
/// `SyncConflictResolutionChoiceBiasDetector`自体は1回の直近履歴
/// ウィンドウのみを見る単発判定であり、解消の確認自体は見ない。実際の
/// 解決ロジックの見直しはアプリ側の責務とする。
class SyncConflictResolutionChoiceBiasRecoveryDetector {
  const SyncConflictResolutionChoiceBiasRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonBiasedCount) {
    return consecutiveNonBiasedCount >= recoveryThreshold;
  }
}
