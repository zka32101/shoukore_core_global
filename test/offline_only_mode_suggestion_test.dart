import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const suggestion = OfflineOnlyModeSuggestion(
    minimumExhaustedCount: 3,
    retryBackoffPolicy: RetryBackoffPolicy(maxAttempts: 8),
  );
  final now = DateTime(2024, 1, 1);

  PendingSyncItem item(int retryCount) => PendingSyncItem(
        id: 'id_$retryCount',
        payload: const {},
        createdAt: now,
        retryCount: retryCount,
      );

  test('諦め状態のアイテムが閾値未満なら提案しない', () {
    expect(suggestion.shouldSuggest([item(8), item(8)]), isFalse);
  });

  test('諦め状態のアイテムが閾値以上なら提案する', () {
    expect(suggestion.shouldSuggest([item(8), item(8), item(8)]), isTrue);
  });

  test('まだ再送可能なアイテムは諦め状態に数えない', () {
    expect(suggestion.shouldSuggest([item(1), item(2), item(3)]), isFalse);
  });
}
