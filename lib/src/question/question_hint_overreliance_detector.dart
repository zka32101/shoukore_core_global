/// 直近の出題でのヒント利用回数から、ヒントへの過度な依存が続いているかを
/// 判定する純関数。`MasteryRapidDecayDetector`は習熟度スコアの減衰量を見る
/// ものでヒント利用自体は見ない。`UnitRecommendationIgnoredDetector`は
/// 推奨単元が無視されているかを見るものでヒント利用とは無関係。実際の
/// ヒントUI・利用回数の記録はアプリ側の責務とする。
class QuestionHintOverrelianceDetector {
  const QuestionHintOverrelianceDetector({this.usageCountThreshold = 5})
      : assert(usageCountThreshold > 0);

  /// 直近の出題件数の中でこの回数以上ヒントを使っていれば過度な依存とみなす。
  final int usageCountThreshold;

  /// [recentHintUsedFlags]（直近の出題ごとにヒントを使ったかどうかの
  /// リスト、古い順）のうちヒントを使った件数が[usageCountThreshold]以上
  /// であれば過度な依存と判定する。
  bool isOverreliant(List<bool> recentHintUsedFlags) {
    final usedCount = recentHintUsedFlags.where((used) => used).length;
    return usedCount >= usageCountThreshold;
  }
}
