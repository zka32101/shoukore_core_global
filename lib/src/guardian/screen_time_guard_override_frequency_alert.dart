/// 保護者が利用時間制限（`ScreenTimeGuard`）を頻繁に一時解除している
/// 状態を検知する純関数。`ScreenTimeWarningThreshold`は残り時間が少ない
/// ことの事前警告のみを見るため、制限解除操作自体の頻度は見ない。
/// `ScreenTimeGuard`自体は制限超過判定のみを行い、解除操作の記録は
/// アプリ側が別途管理する。実際の「制限の見直しを検討しますか」案内の
/// 表示はアプリ側の責務とする。
class ScreenTimeGuardOverrideFrequencyAlert {
  const ScreenTimeGuardOverrideFrequencyAlert({
    this.window = const Duration(days: 7),
    this.overrideThreshold = 3,
  }) : assert(overrideThreshold > 0);

  /// 解除回数を数える期間。
  final Duration window;

  /// この期間内の解除回数がこの件数以上であれば頻発とみなす。
  final int overrideThreshold;

  /// [overrideTimestamps]（直近の制限解除が行われた時刻の一覧）のうち、
  /// [now]から[window]以内のものの件数が[overrideThreshold]以上であれば
  /// 頻発していると判定する。
  bool isFrequentlyOverridden({
    required List<DateTime> overrideTimestamps,
    required DateTime now,
  }) {
    final recentCount =
        overrideTimestamps.where((t) => now.difference(t) <= window).length;
    return recentCount >= overrideThreshold;
  }
}
