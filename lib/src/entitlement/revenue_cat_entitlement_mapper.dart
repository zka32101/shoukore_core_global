import 'package:purchases_flutter/purchases_flutter.dart';

import '../models/models.dart';

/// RevenueCatの`CustomerInfo`から本コアの`Entitlement`へ変換する純関数。
///
/// RevenueCatダッシュボードで設定するentitlement識別子と、教科ID(subjectId)・
/// premiumの対応はアプリ・国ごとに異なるため、呼び出し側が
/// [subjectEntitlementIds]（教科ID→RevenueCat entitlement識別子）と
/// [premiumEntitlementId]を渡す。本コアは「どのentitlementがpremiumか」を
/// 規定しない。
Entitlement entitlementFromCustomerInfo(
  CustomerInfo info, {
  required Map<String, String> subjectEntitlementIds,
  String? premiumEntitlementId,
}) {
  final active = info.entitlements.active;
  final unlockedSubjectIds = <String>{
    for (final entry in subjectEntitlementIds.entries)
      if (active.containsKey(entry.value)) entry.key,
  };
  final isPremium = premiumEntitlementId != null && active.containsKey(premiumEntitlementId);
  return Entitlement(unlockedSubjectIds: unlockedSubjectIds, isPremium: isPremium);
}
