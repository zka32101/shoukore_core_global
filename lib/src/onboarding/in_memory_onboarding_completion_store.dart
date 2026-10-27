import 'onboarding_completion_store.dart';

/// テスト・プロトタイプ用の`OnboardingCompletionStore`実装。
/// 実運用では端末内永続化実装に置き換える。
class InMemoryOnboardingCompletionStore implements OnboardingCompletionStore {
  bool _completed = false;

  @override
  Future<bool> isCompleted() async => _completed;

  @override
  Future<void> markCompleted() async => _completed = true;
}
