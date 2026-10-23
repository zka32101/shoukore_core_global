/// `OfflineSessionGapDetector`が検知した長時間オフラインが解消し、
/// 連続して短い起動間隔が続いているかを判定する純関数。
/// `OfflineSessionGapDetector`自体は直近1回分の起動間隔のみを見る単発
/// 判定であり、解消の確認自体は見ない。`OfflineSessionGapRecurrenceDetector`
/// は長時間オフラインが繰り返されているかを見るもので、本クラスはその
/// 逆軸（解消の確認）を見る。実際の復帰時UI・再同期トリガーの解除方法
/// の見直しはアプリ側の責務とする。
class OfflineSessionGapRecoveryDetector {
  const OfflineSessionGapRecoveryDetector({this.recoveryThreshold = 3})
      : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonLongGapCount) {
    return consecutiveNonLongGapCount >= recoveryThreshold;
  }
}
