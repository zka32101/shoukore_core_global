/// `MasteryAcrossUnitsStagnationDetector`が複数単元習熟度の全体的な
/// 停滞を検知した結果が、単発ではなく確認のたびに繰り返し検出され続け
/// ているかを判定する純関数。`MasteryAcrossUnitsStagnationDetector`
/// 自体は直近2回分のスナップショットの比較1回分のみを見るため、繰り
/// 返しの発生自体は見ない。実際の学習内容の見直し提案・通知の表示方法
/// の見直しはアプリ側の責務とする。
class MasteryAcrossUnitsStagnationRecurrenceDetector {
  const MasteryAcrossUnitsStagnationRecurrenceDetector({this.recurrenceThreshold = 3})
      : assert(recurrenceThreshold > 0);

  /// 連続してこの回数以上停滞が検出されたら繰り返しとみなす。
  final int recurrenceThreshold;

  /// [consecutiveStagnationCount]（直近から連続して全体的な停滞が
  /// 検出された回数）が[recurrenceThreshold]以上であれば、繰り返し
  /// 検出されている状態と判定する。
  bool isRecurring(int consecutiveStagnationCount) {
    return consecutiveStagnationCount >= recurrenceThreshold;
  }
}
