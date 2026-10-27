/// 初回起動時のオンボーディング（ウェルカム→Ahaモーメント→ペイウォール等）を
/// 完了済みかどうかを保持する。オンボーディングの構成・ページ内容はアプリ側の
/// 責務。コアは「完了したかどうか」の記録のみを担う。
abstract class OnboardingCompletionStore {
  Future<bool> isCompleted();

  Future<void> markCompleted();
}
