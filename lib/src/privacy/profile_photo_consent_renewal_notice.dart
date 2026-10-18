import 'profile_photo_consent_gate.dart';

/// `ProfilePhotoConsent`の同意取得から長期間経過している場合、現在も
/// 有効な同意として扱ってよいか再確認を促すべきかを判定する純関数。
/// `ProfilePhotoConsentGate`（同意の有無のみを見る判定）・
/// `PhotoConsentExpiryCascade`（同意取り消し後の写真削除判定）とは異なり、
/// 本クラスは同意が取り消されていなくても、取得時刻からの経過時間が
/// 長すぎる場合のみを見る。実際の再確認ダイアログの表示はアプリ側の
/// 責務とする。
class ProfilePhotoConsentRenewalNotice {
  const ProfilePhotoConsentRenewalNotice({this.stalenessPeriod = const Duration(days: 365)});

  /// 同意取得からこの期間を超えていれば、再確認を提案すべきと判定する。
  final Duration stalenessPeriod;

  /// [consent]が`null`、または[ProfilePhotoConsent.granted]が`false`の
  /// 場合は提案不要（`ProfilePhotoConsentGate`が同意取得フローを扱う）。
  /// 同意済みで[ProfilePhotoConsent.grantedAt]からの経過時間が
  /// [stalenessPeriod]を超えていれば、再確認を提案すべきと判定する。
  bool shouldSuggestRenewal({required ProfilePhotoConsent? consent, required DateTime now}) {
    if (consent == null || !consent.granted || consent.grantedAt == null) {
      return false;
    }
    return now.difference(consent.grantedAt!) > stalenessPeriod;
  }
}
