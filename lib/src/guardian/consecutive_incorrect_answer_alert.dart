import '../models/models.dart';

/// 直近の回答が連続して不正解続きの場合に、保護者へアラートを出すべきかを
/// 判定する純関数。実際の通知送信・UI表示はアプリ側（`NotificationScheduler`
/// 等）の責務とする。
class ConsecutiveIncorrectAnswerAlert {
  const ConsecutiveIncorrectAnswerAlert({this.alertThreshold = 3})
      : assert(alertThreshold > 0);

  /// この回数以上連続で不正解が続いたらアラート対象とする。
  final int alertThreshold;

  /// [recentAttemptsNewestFirst]（直近の回答履歴、新しい順）の先頭から
  /// 連続して不正解が続いている回数を数え、[alertThreshold]以上であれば
  /// アラート対象と判定する。
  bool shouldAlert(List<Attempt> recentAttemptsNewestFirst) {
    var streak = 0;
    for (final attempt in recentAttemptsNewestFirst) {
      if (attempt.correct) break;
      streak++;
    }
    return streak >= alertThreshold;
  }
}
