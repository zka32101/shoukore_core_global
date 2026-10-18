import '../models/models.dart';

/// 端末にキャッシュされている[RegionalProfile]と、`regional/{locale}.yaml`
/// から新たに読み込んだ最新の[RegionalProfile]を比較し、同意年齢・保護者
/// 同意要否・利用時間制限などの内容が変わっていないかを検知する純関数。
/// `LocaleCurriculumStalenessNotice`はロケール文字列の一致のみを見て
/// カリキュラムの読み込み有無を判定するため、プロフィール自体の内容変化は
/// 見ない。`TimeZoneDriftDetector`は端末のタイムゾーンのみを見るため、
/// 同意年齢や利用時間制限等の変化は見ない。実際の再確認案内の表示は
/// アプリ側の責務とする。
class RegionalProfileChangeDetector {
  const RegionalProfileChangeDetector();

  /// [cached]（前回キャッシュしたプロフィール）と[latest]（最新の
  /// プロフィール）の内容が異なる場合に`true`を返す。[cached]が`null`
  /// （まだキャッシュがない）の場合は変化なしとして`false`を返す。
  bool hasChanged({required RegionalProfile? cached, required RegionalProfile latest}) {
    if (cached == null) return false;
    return cached.locale != latest.locale ||
        cached.ageOfConsent != latest.ageOfConsent ||
        cached.guardianConsentRequired != latest.guardianConsentRequired ||
        cached.dailyResetHour != latest.dailyResetHour ||
        cached.timeZone != latest.timeZone ||
        cached.screenTimeLimitMinutes != latest.screenTimeLimitMinutes ||
        cached.profilingAdsAllowed != latest.profilingAdsAllowed;
  }
}
