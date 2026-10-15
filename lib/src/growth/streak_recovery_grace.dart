import 'daily_boundary.dart';

/// `LearningStreak`が1日途切れた場合に、当日中の挽回でストリークを
/// 継続扱いにできる「見逃し猶予」を判定する純関数。`LearningStreak.recordStudy`
/// は間隔が空くと厳密にストリークを1にリセットするが、本クラスは
/// モチベーション維持のため、途切れてから[graceDays]日以内の学習であれば
/// 継続扱いにしてよいと判定するだけで、実際にストリークを復元する処理
/// （`LearningStreak`の再構築、復元の演出・通知等）はアプリ側の責務とする。
class StreakRecoveryGrace {
  const StreakRecoveryGrace({this.graceDays = 1}) : assert(graceDays > 0);

  /// 最後の学習日から何日以内の学習なら「見逃し」として許容するか。
  final int graceDays;

  /// [lastStudiedDay]（最後に学習したミッション日）から[now]までの間隔が、
  /// 連続（翌日）ではないが[graceDays]日以内であれば、見逃し猶予の対象
  /// （継続扱いにしてよい）と判定する。[lastStudiedDay]が`null`、または
  /// 間隔が[graceDays]日を超えている場合は`false`を返す。
  bool isRecoverable({
    required DateTime? lastStudiedDay,
    required DateTime now,
    required DailyBoundary boundary,
  }) {
    if (lastStudiedDay == null) return false;
    final today = boundary.missionDayOf(now);
    final missedDays = today.difference(boundary.missionDayOf(lastStudiedDay)).inDays;
    return missedDays > 1 && missedDays <= graceDays + 1;
  }
}
