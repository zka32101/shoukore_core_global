import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const policy = RetryBackoffPolicy(
    baseDelay: Duration(seconds: 30),
    maxDelay: Duration(minutes: 10),
    maxAttempts: 4,
  );

  group('nextDelay', () {
    test('retryCount:0は基準時間', () {
      final item = PendingSyncItem(
        id: '1',
        payload: const {},
        createdAt: DateTime(2024, 1, 1),
      );
      expect(policy.nextDelay(item), const Duration(seconds: 30));
    });

    test('失敗を重ねるごとに倍になる', () {
      final item = PendingSyncItem(
        id: '1',
        payload: const {},
        createdAt: DateTime(2024, 1, 1),
        retryCount: 2,
      );
      expect(policy.nextDelay(item), const Duration(seconds: 120));
    });

    test('maxDelayを超えない', () {
      final item = PendingSyncItem(
        id: '1',
        payload: const {},
        createdAt: DateTime(2024, 1, 1),
        retryCount: 10,
      );
      expect(policy.nextDelay(item), const Duration(minutes: 10));
    });
  });

  group('shouldRetryNow', () {
    test('待機時間を過ぎていればtrue', () {
      final item = PendingSyncItem(
        id: '1',
        payload: const {},
        createdAt: DateTime(2024, 1, 1, 0, 0, 0),
      );
      expect(policy.shouldRetryNow(item, DateTime(2024, 1, 1, 0, 0, 31)), isTrue);
    });

    test('待機時間内はfalse', () {
      final item = PendingSyncItem(
        id: '1',
        payload: const {},
        createdAt: DateTime(2024, 1, 1, 0, 0, 0),
      );
      expect(policy.shouldRetryNow(item, DateTime(2024, 1, 1, 0, 0, 10)), isFalse);
    });

    test('maxAttempts到達後はfalse', () {
      final item = PendingSyncItem(
        id: '1',
        payload: const {},
        createdAt: DateTime(2024, 1, 1),
        retryCount: 4,
      );
      expect(policy.shouldRetryNow(item, DateTime(2025, 1, 1)), isFalse);
    });
  });

  test('hasExhaustedRetriesはmaxAttempts以上でtrue', () {
    final item = PendingSyncItem(
      id: '1',
      payload: const {},
      createdAt: DateTime(2024, 1, 1),
      retryCount: 4,
    );
    expect(policy.hasExhaustedRetries(item), isTrue);
    final underItem = PendingSyncItem(
      id: '1',
      payload: const {},
      createdAt: DateTime(2024, 1, 1),
      retryCount: 3,
    );
    expect(policy.hasExhaustedRetries(underItem), isFalse);
  });
}
