import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const gate = ProfilePhotoConsentGate();

  test('同意記録がない場合は同意が必要', () {
    expect(gate.requiresConsent(null), isTrue);
  });

  test('同意が拒否されている場合は同意が必要', () {
    const consent = ProfilePhotoConsent(granted: false);
    expect(gate.requiresConsent(consent), isTrue);
  });

  test('同意済みなら不要', () {
    final consent = ProfilePhotoConsent(granted: true, grantedAt: DateTime(2024, 1, 1));
    expect(gate.requiresConsent(consent), isFalse);
  });
}
