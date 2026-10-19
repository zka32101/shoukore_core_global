/// 未解消の弱点ノート件数の履歴から、件数自体ではなく増加の速さ
/// （前回の記録からの増加分）が加速しているかを判定する純関数。
/// `WeakNoteBacklogSizeAlert`は件数の絶対的な閾値のみを見るため、
/// 増加ペース自体は見ない。実際の「まとめて復習しよう」案内の表示は
/// アプリ側の責務とする。
class WeakNoteBacklogGrowthRateAlert {
  const WeakNoteBacklogGrowthRateAlert({this.growthCountThreshold = 3})
      : assert(growthCountThreshold > 0);

  /// 直近の記録間でこの件数以上増えていたら急増とみなす。
  final int growthCountThreshold;

  /// [previousUnresolvedCount]（前回記録時点の未解消件数）から
  /// [currentUnresolvedCount]（現在の未解消件数）への増加分が
  /// [growthCountThreshold]以上であれば急増と判定する。
  bool isGrowingRapidly({
    required int previousUnresolvedCount,
    required int currentUnresolvedCount,
  }) {
    return (currentUnresolvedCount - previousUnresolvedCount) >= growthCountThreshold;
  }
}
