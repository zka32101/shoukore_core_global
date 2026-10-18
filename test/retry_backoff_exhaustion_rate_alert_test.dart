import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('RetryBackoffExhaustionRateAlert', () {
    const alert = RetryBackoffExhaustionRateAlert(exhaustionRateThreshold: 0.5);

    test('枯渇件数の割合が閾値以上ならシステム的な障害と判定', () {
      expect(
        alert.isSystemicFailure(exhaustedCount: 5, totalPendingCount: 10),
        isTrue,
      );
    });

    test('枯渇件数の割合が閾値未満ならシステム的な障害ではない', () {
      expect(
        alert.isSystemicFailure(exhaustedCount: 2, totalPendingCount: 10),
        isFalse,
      );
    });

    test('同期待ちが0件なら判定しない', () {
      expect(
        alert.isSystemicFailure(exhaustedCount: 0, totalPendingCount: 0),
        isFalse,
      );
    });
  });
}
