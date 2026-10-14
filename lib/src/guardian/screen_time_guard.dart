import '../models/models.dart';

/// 利用時間制限（ECA Digitalの保護者監督ツール対応）。`profile.screenTimeLimitMinutes` が
/// 0 なら制限なし。時間の計測自体はアプリ側（`Clock`経由の計測）に委ねる。
class ScreenTimeGuard {
  const ScreenTimeGuard(this.profile);

  final RegionalProfile profile;

  bool get isLimited => profile.screenTimeLimitMinutes > 0;

  bool isOverLimit(Duration usedToday) =>
      isLimited && usedToday.inMinutes >= profile.screenTimeLimitMinutes;

  Duration remaining(Duration usedToday) {
    if (!isLimited) return Duration.zero;
    final remainingMinutes = profile.screenTimeLimitMinutes - usedToday.inMinutes;
    return Duration(minutes: remainingMinutes < 0 ? 0 : remainingMinutes);
  }
}
