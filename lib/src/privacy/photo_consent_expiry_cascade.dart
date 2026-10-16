import 'profile_photo_consent_gate.dart';

/// プロフィール写真利用の同意（[ProfilePhotoConsent]）が失効した場合、
/// 既に保存済みの写真そのものも削除対象にすべきかを判定する純関数。
/// `ProfilePhotoConsentGate`（新規利用前の同意確認）とは異なり、
/// 既に同意済みで利用していた写真が、同意取り消し後も残り続けることを
/// 防ぐための事後判定を扱う。実際の写真削除処理はアプリ側の責務とする。
class PhotoConsentExpiryCascade {
  const PhotoConsentExpiryCascade();

  /// [consent]が`null`、または[ProfilePhotoConsent.granted]が`false`で
  /// あるにもかかわらず[hasStoredPhoto]が`true`の場合、保存済み写真を
  /// 削除すべきと判定する。
  bool shouldDeleteStoredPhoto({
    required ProfilePhotoConsent? consent,
    required bool hasStoredPhoto,
  }) {
    if (!hasStoredPhoto) return false;
    if (consent == null) return true;
    return !consent.granted;
  }
}
