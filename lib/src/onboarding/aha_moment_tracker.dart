/// Ahaモーメント（オンボーディング中の最初の正解体験）への到達を判定する。
///
/// 「今回の回答で新たに到達したか」のみを返す純関数で、到達済みフラグの
/// 永続化はアプリ側（`OnboardingCompletionStore`等）の責務とする。
class AhaMomentTracker {
  const AhaMomentTracker();

  /// [alreadyReached]が`false`かつ[correct]が`true`の場合のみ、
  /// 今回の回答で新たにAhaモーメントに到達したと判定する。
  /// 既に到達済みの場合は、以降の正解・不正解にかかわらず重複して到達扱いにしない。
  bool reachedOnThisAnswer({required bool alreadyReached, required bool correct}) {
    return !alreadyReached && correct;
  }
}
