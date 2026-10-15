/// 保護者が自ら指定した期間、週次レポート・日次ダイジェストの通知を
/// 一時停止すべきかを判定する純関数。`QuietHoursGuard`（子供側の毎日の
/// 静かな時間帯）とは異なり、保護者側が設定する任意の開始〜終了日時の
/// ミュート期間を扱う。実際の通知停止処理・設定UIはアプリ側の責務とする。
class GuardianDigestMuteWindow {
  const GuardianDigestMuteWindow({this.mutedUntil});

  /// この時刻までダイジェスト通知をミュートする。`null`はミュートなし。
  final DateTime? mutedUntil;

  /// [at]時点でミュート期間中であれば`true`を返す。
  bool isMutedAt(DateTime at) {
    if (mutedUntil == null) return false;
    return at.isBefore(mutedUntil!);
  }
}
