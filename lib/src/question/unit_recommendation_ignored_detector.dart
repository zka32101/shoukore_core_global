/// `UnitRecommendation`が提案した単元が、何度も表示されても学習されずに
/// 無視され続けていないかを判定する純関数。`UnitRecommendation`自体は
/// 単元の優先順位付けのみを行い、提案が実際に見送られ続けているかは
/// 見ないため、本クラスがアプリ側が記録する提示回数を見る。実際の提案
/// 内容の変更・別単元への切り替えはアプリ側の責務とする。
class UnitRecommendationIgnoredDetector {
  const UnitRecommendationIgnoredDetector({this.maxPresentationsBeforeIgnored = 5});

  /// この回数提示されても着手されなければ無視されたとみなす。
  final int maxPresentationsBeforeIgnored;

  /// [presentedCount]（同じ単元が最優先として提示された回数）が
  /// [maxPresentationsBeforeIgnored]以上であれば無視されたと判定する。
  bool isIgnored(int presentedCount) {
    return presentedCount >= maxPresentationsBeforeIgnored;
  }
}
