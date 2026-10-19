/// 同一内容の通知の重複予約が繰り返し発生している状態を検知する純関数。
/// `DuplicateNotificationScheduleDetector`は1回の予約時点で重複が存在するか
/// どうかのみを判定し、それが繰り返し起きているかは見ない。本クラスは
/// アプリ側から渡される連続発生回数を見て、重複予約が繰り返し起きている
/// 状態かどうかを判定する。実際のスケジューリングロジックの見直し案内は
/// アプリ側の責務とする。
class DuplicateNotificationScheduleRecurrenceDetector {
  const DuplicateNotificationScheduleRecurrenceDetector({this.recurrenceThreshold = 3})
      : assert(recurrenceThreshold > 0);

  /// 連続発生がこの回数以上になったら繰り返し発生とみなす。
  final int recurrenceThreshold;

  /// [consecutiveDuplicateCount]（直近から連続して発生した重複予約の回数）
  /// が[recurrenceThreshold]以上であれば、繰り返し発生と判定する。
  bool isRecurring(int consecutiveDuplicateCount) {
    return consecutiveDuplicateCount >= recurrenceThreshold;
  }
}
