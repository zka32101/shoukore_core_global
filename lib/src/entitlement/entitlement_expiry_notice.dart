/// 課金プランの有効期限切れが近いことを事前に知らせるべきかを判定する
/// 純関数。`EntitlementGracePeriod`（失効後の猶予期間判定）とは異なり、
/// 本クラスは失効前の時点で、期限が近づいていることに気づけるようにする。
/// `Entitlement`自体やストアからの期限取得はアプリ側（`EntitlementReader`
/// 等のRevenueCat実装）の責務とし、本コアは期限までの残り時間の判定
/// のみを担う。実際の通知表示・更新手続きの案内はアプリ側の責務とする。
class EntitlementExpiryNotice {
  const EntitlementExpiryNotice({this.noticeWindow = const Duration(days: 3)});

  /// 期限までこの期間を切ったら通知対象とする。
  final Duration noticeWindow;

  /// [expiresAt]（課金の有効期限）までの残り時間が[noticeWindow]以内、
  /// かつ既に失効していなければ通知すべきと判定する。
  bool shouldNotify({required DateTime expiresAt, required DateTime now}) {
    final remaining = expiresAt.difference(now);
    return !remaining.isNegative && remaining <= noticeWindow;
  }
}
