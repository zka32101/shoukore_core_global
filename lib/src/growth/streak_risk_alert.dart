import 'daily_boundary.dart';

/// `LearningStreak`が当日中に学習しないと途切れてしまう状態で、
/// ミッション日の残り時間が少なくなっている場合にリマインドすべきかを
/// 判定する純関数。`LearningStreak`自体はストリークの計算のみを行うため、
/// 本クラスが「今日まだ学習していない」かつ「残り時間が少ない」の両方を
/// 見る。実際のリマインド表示・通知送信はアプリ側の責務とする。
class StreakRiskAlert {
  const StreakRiskAlert({this.remainingTimeThreshold = const Duration(hours: 2)});

  /// ミッション日の終わりまでこの時間を切ったらアラート対象とする。
  final Duration remainingTimeThreshold;

  /// [lastStudiedDay]（最後に学習したミッション日）が[now]時点のミッション日
  /// と異なり（今日まだ学習していない）、かつ現在の日から次のミッション日
  /// 境界までの残り時間が[remainingTimeThreshold]以下であればアラート
  /// すべきと判定する。
  bool shouldAlert({
    required DateTime? lastStudiedDay,
    required DateTime now,
    required DailyBoundary boundary,
  }) {
    final hasStudiedToday = lastStudiedDay != null && boundary.isSameMissionDay(lastStudiedDay, now);
    if (hasStudiedToday) return false;

    // `now`と同じ時刻系（UTC/ローカル）で次のミッション日境界を組み立てる。
    // `DailyBoundary.missionDayOf`はUTCの日付を返すため、`now`がローカル
    // 時刻の場合に直接比較すると時差分のズレが生じるのを避ける。
    final shifted = now.subtract(Duration(hours: boundary.profile.dailyResetHour));
    final startOfShiftedDay = shifted.isUtc
        ? DateTime.utc(shifted.year, shifted.month, shifted.day)
        : DateTime(shifted.year, shifted.month, shifted.day);
    final nextBoundary =
        startOfShiftedDay.add(Duration(days: 1, hours: boundary.profile.dailyResetHour));
    return nextBoundary.difference(now) <= remainingTimeThreshold;
  }
}
