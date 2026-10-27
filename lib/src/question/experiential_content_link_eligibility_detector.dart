/// 実体験に紐づく体験型コンテンツ（例題・補足説明等）を提示すべき
/// 対象単元かどうかを判定する純関数。カリキュラム側で体験型
/// コンテンツが用意されている単元のうち、基礎的な理解がまだ不十分
/// な段階では提示を見送り、ある程度の正答率に達した単元でのみ
/// 提示する場面向け。実際の体験型コンテンツの内容・表示自体は
/// アプリ側の責務とする。
class ExperientialContentLinkEligibilityDetector {
  const ExperientialContentLinkEligibilityDetector({
    this.minAccuracyRatio = 0.5,
  }) : assert(minAccuracyRatio >= 0 && minAccuracyRatio <= 1);

  /// 体験型コンテンツを提示する最低正答率（0.0〜1.0）。
  final double minAccuracyRatio;

  /// [unitHasExperientialContent]（単元に体験型コンテンツが用意
  /// されているか）が真、かつ[accuracyRatio]（単元内の正答率）が
  /// [minAccuracyRatio]以上であれば、提示対象と判定する。
  bool isEligible(bool unitHasExperientialContent, double accuracyRatio) {
    return unitHasExperientialContent && accuracyRatio >= minAccuracyRatio;
  }
}
