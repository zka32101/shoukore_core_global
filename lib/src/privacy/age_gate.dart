import '../clock/clock.dart';
import '../models/models.dart';

/// 年齢確認フロー。LGPD第14条・ECA Digital対応のため、保護者同意の要否を
/// `RegionalProfile`（地域ごとの同意年齢）とClockから純粋に判定する。
class AgeGate {
  const AgeGate();

  bool requiresGuardianConsent({
    required int birthYear,
    required RegionalProfile profile,
    required Clock clock,
  }) {
    if (!profile.guardianConsentRequired) return false;
    final age = clock.now().year - birthYear;
    return age < profile.ageOfConsent;
  }
}
