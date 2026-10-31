import '../clock/clock.dart';
import '../models/models.dart';
import 'age_gate.dart';
import 'consent_store.dart';

/// 年齢確認・保護者同意の判定・記録を一連の流れとしてまとめた、UI非依存の
/// ヘルパー。`AgeGate`(判定のみ)・`ConsentStore`(記録のみ)という既存の
/// 単機能部品を、実際のオンボーディング/設定画面でそのまま使える形に
/// 組み合わせたもの。年齢確認フロー自体は全教科・全国共通で必要になるため、
/// 各アプリで同じ組み合わせ方を再実装しなくて済むようにする。
class AgeGateConsentCoordinator {
  const AgeGateConsentCoordinator({this.ageGate = const AgeGate()});

  final AgeGate ageGate;

  /// 入力された生年から保護者同意が必要かを判定する。必要なければその場で
  /// 「同意不要」の記録をして`false`を返す。必要なら何も記録せず`true`を
  /// 返す(呼び出し側が保護者同意の質問を表示し、[recordConsentAnswer]で
  /// 結果を記録する)。
  Future<bool> requiresConsentAndRecordIfNot({
    required int birthYear,
    required RegionalProfile profile,
    required Clock clock,
    required ConsentStore consentStore,
  }) async {
    final requiresConsent = ageGate.requiresGuardianConsent(
      birthYear: birthYear,
      profile: profile,
      clock: clock,
    );
    if (!requiresConsent) {
      await consentStore.setConsent(const ConsentRecord(parentalConsentGiven: false));
    }
    return requiresConsent;
  }

  /// 保護者同意の質問への回答を記録する。
  Future<void> recordConsentAnswer({
    required ConsentStore consentStore,
    required Clock clock,
    required bool accepted,
  }) {
    return consentStore.setConsent(ConsentRecord(
      parentalConsentGiven: accepted,
      consentedAt: accepted ? clock.now() : null,
    ));
  }
}
