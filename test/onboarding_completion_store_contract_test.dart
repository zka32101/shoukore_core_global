import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

/// `OnboardingCompletionStore`の実装はいずれも同じ契約を満たす必要がある。
/// 新しい実装を追加したら、この関数を呼ぶテストを追加すること。
void runOnboardingCompletionStoreContractTests(
  String label,
  OnboardingCompletionStore Function() createStore,
) {
  group(label, () {
    late OnboardingCompletionStore store;

    setUp(() => store = createStore());

    test('未保存状態では未完了を返す', () async {
      expect(await store.isCompleted(), isFalse);
    });

    test('markCompleted後はisCompletedがtrueになる', () async {
      await store.markCompleted();
      expect(await store.isCompleted(), isTrue);
    });

    test('markCompletedを繰り返しても完了状態を維持する', () async {
      await store.markCompleted();
      await store.markCompleted();
      expect(await store.isCompleted(), isTrue);
    });
  });
}

void main() {
  runOnboardingCompletionStoreContractTests(
    'InMemoryOnboardingCompletionStore',
    () => InMemoryOnboardingCompletionStore(),
  );
}
