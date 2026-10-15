import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const policy = StaleDataPolicy(staleAfter: Duration(days: 14));

  group('isStale', () {
    test('一度も同期されていない(null)ならtrue', () {
      expect(policy.isStale(null, DateTime(2024, 1, 1)), isTrue);
    });

    test('staleAfter以内ならfalse', () {
      final lastSyncedAt = DateTime(2024, 1, 1);
      expect(policy.isStale(lastSyncedAt, DateTime(2024, 1, 10)), isFalse);
    });

    test('staleAfterを超えればtrue', () {
      final lastSyncedAt = DateTime(2024, 1, 1);
      expect(policy.isStale(lastSyncedAt, DateTime(2024, 1, 16)), isTrue);
    });
  });

  group('remainingUntilStale', () {
    test('要同期ならゼロ', () {
      expect(policy.remainingUntilStale(null, DateTime(2024, 1, 1)), Duration.zero);
    });

    test('未満なら残り時間を返す', () {
      final lastSyncedAt = DateTime(2024, 1, 1);
      expect(
        policy.remainingUntilStale(lastSyncedAt, DateTime(2024, 1, 10)),
        const Duration(days: 5),
      );
    });
  });
}
