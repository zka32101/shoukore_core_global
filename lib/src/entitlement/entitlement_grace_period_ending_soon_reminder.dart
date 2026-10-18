import 'entitlement_grace_period.dart';

/// `EntitlementGracePeriod`による猶予期間が終了間近であることを事前に
/// 知らせるべきかを判定する純関数。`EntitlementGracePeriod`自体は猶予期間
/// 中かどうかの二値判定のみを行い、終了までの残り時間が近いことの事前
/// 通知は見ないため、本クラスが独立してその判定を行う。実際の「もうすぐ
/// 猶予期間が終了します」表示はアプリ側の責務とする。
class EntitlementGracePeriodEndingSoonReminder {
  const EntitlementGracePeriodEndingSoonReminder({this.remainingTimeThreshold = const Duration(hours: 24)});

  /// 猶予期間の終了までこの時間を切ったら「もうすぐ終了」とみなす。
  final Duration remainingTimeThreshold;

  /// [expiredAt]と[gracePeriod]から求まる猶予終了時刻までの、[now]からの
  /// 残り時間が[remainingTimeThreshold]以下であれば終了間近と判定する。
  /// 猶予期間自体が既に終了している場合は`false`を返す。
  bool isEndingSoon({
    required DateTime expiredAt,
    required DateTime now,
    required EntitlementGracePeriod gracePeriod,
  }) {
    if (!gracePeriod.isWithinGrace(expiredAt: expiredAt, now: now)) return false;
    final graceEndsAt = gracePeriod.graceEndsAt(expiredAt);
    return graceEndsAt.difference(now) <= remainingTimeThreshold;
  }
}
