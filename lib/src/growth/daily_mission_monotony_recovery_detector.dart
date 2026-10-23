/// `DailyMissionMonotonyDetector`が検知したデイリーミッションのマンネリ化
/// が解消し、連続して種類の多様性が戻っていると判定され続けているかを
/// 判定する純関数。`DailyMissionMonotonyDetector`自体は1回の直近履歴
/// ウィンドウのみを見る単発判定であり、解消の確認自体は見ない。実際の
/// ミッション種類の選定ロジックの見直しはアプリ側の責務とする。
class DailyMissionMonotonyRecoveryDetector {
  const DailyMissionMonotonyRecoveryDetector({this.recoveryThreshold = 3})
      : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonMonotonousCount) {
    return consecutiveNonMonotonousCount >= recoveryThreshold;
  }
}
