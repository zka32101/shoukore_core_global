import 'screen_time_guard.dart';

/// `ScreenTimeGuard`が制限超過と判定する前に、残り時間が少なくなったことを
/// 事前に警告すべきかを判定する純関数。制限自体の判定は`ScreenTimeGuard`に
/// 委ね、本クラスは残り時間が閾値（割合）を下回ったかを見るだけで、
/// 実際の警告UI・通知の表示はアプリ側の責務とする。
class ScreenTimeWarningThreshold {
  const ScreenTimeWarningThreshold({this.warnAtRemainingRatio = 0.1})
      : assert(warnAtRemainingRatio > 0 && warnAtRemainingRatio < 1);

  /// 残り時間の割合がこれ以下になったら警告すべきと判定する。
  final double warnAtRemainingRatio;

  /// [guard]が制限ありで、かつ未超過のまま残り時間の割合が
  /// [warnAtRemainingRatio]以下になっていれば、警告すべきと判定する。
  /// 既に制限超過の場合は`false`を返す（それは`ScreenTimeGuard.isOverLimit`
  /// が扱う別の状態のため）。
  bool shouldWarn(ScreenTimeGuard guard, Duration usedToday) {
    if (!guard.isLimited) return false;
    if (guard.isOverLimit(usedToday)) return false;
    final limitMinutes = guard.profile.screenTimeLimitMinutes;
    final remainingMinutes = guard.remaining(usedToday).inMinutes;
    return remainingMinutes / limitMinutes <= warnAtRemainingRatio;
  }
}
