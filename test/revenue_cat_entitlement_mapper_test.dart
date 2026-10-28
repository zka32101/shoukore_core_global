import 'package:flutter_test/flutter_test.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shoukore_core_global/shoukore_core_global_entitlement_revenuecat.dart';

CustomerInfo _customerInfoWithActiveEntitlements(List<String> activeIds) {
  EntitlementInfo entitlementFor(String id) => EntitlementInfo(
        id,
        true,
        true,
        '2026-01-01T00:00:00Z',
        '2026-01-01T00:00:00Z',
        'product_$id',
        false,
      );

  final active = {for (final id in activeIds) id: entitlementFor(id)};
  return CustomerInfo(
    EntitlementInfos(active, active),
    const {},
    const [],
    const [],
    const [],
    '2026-01-01T00:00:00Z',
    'test_user',
    const {},
    '2026-01-01T00:00:00Z',
  );
}

void main() {
  test('対応するentitlementが有効な教科のみunlockedSubjectIdsに含める', () {
    final info = _customerInfoWithActiveEntitlements(['mat_br']);

    final entitlement = entitlementFromCustomerInfo(
      info,
      subjectEntitlementIds: {'matematica': 'mat_br', 'ciencias': 'sci_br'},
    );

    expect(entitlement.unlockedSubjectIds, {'matematica'});
    expect(entitlement.isPremium, isFalse);
  });

  test('premiumEntitlementIdが有効ならisPremiumがtrueになる', () {
    final info = _customerInfoWithActiveEntitlements(['premium']);

    final entitlement = entitlementFromCustomerInfo(
      info,
      subjectEntitlementIds: const {},
      premiumEntitlementId: 'premium',
    );

    expect(entitlement.isPremium, isTrue);
  });

  test('有効なentitlementが無い場合は何も解放しない', () {
    final info = _customerInfoWithActiveEntitlements(const []);

    final entitlement = entitlementFromCustomerInfo(
      info,
      subjectEntitlementIds: {'matematica': 'mat_br'},
      premiumEntitlementId: 'premium',
    );

    expect(entitlement.unlockedSubjectIds, isEmpty);
    expect(entitlement.isPremium, isFalse);
  });
}
