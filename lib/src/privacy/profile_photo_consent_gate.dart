/// プロフィール写真（アバター用カメラ撮影・端末内の画像選択等）の利用に
/// 必要な、目的特化の同意記録。`ConsentRecord`（保護者同意・年齢確認の
/// 全体記録）とは別の、写真利用という特定目的向けの最小構造。
class ProfilePhotoConsent {
  const ProfilePhotoConsent({required this.granted, this.grantedAt});

  final bool granted;
  final DateTime? grantedAt;
}

/// プロフィール写真機能を提供する前に、追加の同意が必要かを判定する
/// 純関数。カメラ撮影・画像保存はカメラロール等の端末リソースへの
/// アクセスを伴うため、年齢確認・基本同意（`ConsentRecord`）とは別に、
/// この目的専用の同意を求める想定。実際の同意取得UI・画像の保存/削除
/// 処理はアプリ側の責務とする。
class ProfilePhotoConsentGate {
  const ProfilePhotoConsentGate();

  /// [consent]が`null`、または[ProfilePhotoConsent.granted]が`false`の場合、
  /// 写真機能の利用前に同意を求めるべきと判定する。
  bool requiresConsent(ProfilePhotoConsent? consent) {
    if (consent == null) return true;
    return !consent.granted;
  }
}
