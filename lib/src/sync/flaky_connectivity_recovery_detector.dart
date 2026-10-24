/// `FlakyConnectivityDetector`が検知した不安定な接続状態が解消し、
/// 連続して安定していると判定され続けているかを判定する純関数。
/// `FlakyConnectivityDetector`自体は1回の直近履歴ウィンドウのみを見る
/// 単発判定であり、解消の確認自体は見ない。実際のオフライン専用モード
/// の解除方法の見直しはアプリ側の責務とする。
class FlakyConnectivityRecoveryDetector {
  const FlakyConnectivityRecoveryDetector({this.recoveryThreshold = 3})
      : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonFlakyCount) {
    return consecutiveNonFlakyCount >= recoveryThreshold;
  }
}
