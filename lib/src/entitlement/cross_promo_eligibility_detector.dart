/// シリーズ内の他教科・他アプリへのクロスプロモーション案内を
/// 表示すべきかどうかを判定する純関数。十分に学習が進んでいて、
/// かつ案内を繰り返し無視していない利用者に限定して表示したい
/// 場面向け。実際の案内先・表示方法自体はアプリ側の責務とする。
class CrossPromoEligibilityDetector {
  const CrossPromoEligibilityDetector({
    this.minMasteredUnitCount = 5,
    this.maxDismissalCount = 3,
  })  : assert(minMasteredUnitCount > 0),
        assert(maxDismissalCount >= 0);

  /// 習得済み単元数がこの値以上であれば、学習が十分進んでいると
  /// みなす。
  final int minMasteredUnitCount;

  /// クロスプロモ案内を無視した回数がこの値以上になったら、
  /// それ以上の表示は抑制する。
  final int maxDismissalCount;

  /// [masteredUnitCount]（習得済み単元数）が[minMasteredUnitCount]
  /// 以上、かつ[dismissalCount]（案内を無視した回数）が
  /// [maxDismissalCount]未満であれば、クロスプロモ案内の表示対象
  /// と判定する。
  bool isEligible(int masteredUnitCount, int dismissalCount) {
    return masteredUnitCount >= minMasteredUnitCount &&
        dismissalCount < maxDismissalCount;
  }
}
