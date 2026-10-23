/// `SyncConflictRecurrenceDetector`が検知した同一レコードでの同期
/// コンフリクトの再発が解消し、連続してコンフリクトなしと判定され
/// 続けているかを判定する純関数。`SyncConflictRecurrenceDetector`
/// 自体は集計期間ごとの発生回数の集計のみを見るため、解消の確認自体
/// は見ない。実際の再発箇所の個別調査・警告表示の解除方法の見直しは
/// アプリ側の責務とする。
class SyncConflictRecoveryDetector {
  const SyncConflictRecoveryDetector({this.recoveryThreshold = 3})
      : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonConflictCount) {
    return consecutiveNonConflictCount >= recoveryThreshold;
  }
}
