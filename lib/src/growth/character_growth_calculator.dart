/// カテゴリ（教科・単元群等、アプリが定義する任意の軸）内の累積正解数から、
/// 複数キャラが順送りで育つ際の各キャラのレベルを計算する純関数。
///
/// 1体あたり[answersPerLevel]×[maxLevel]問正解すると、同じカテゴリ内の
/// 次の育成順（[order]）のキャラの育成が始まる「順送り」方式。カテゴリ
/// 内の正解数の集計方法・何をカテゴリとするか（教科のeixo等）はアプリ側の
/// 責務。
class CharacterGrowthCalculator {
  const CharacterGrowthCalculator({
    this.answersPerLevel = 5,
    this.maxLevel = 5,
  });

  final int answersPerLevel;
  final int maxLevel;

  /// [order]番目（0始まり）のキャラの、[categoryCorrectCount]（カテゴリ内の
  /// 累積正解数）時点でのレベル。0は未所持、1〜[maxLevel]が所持済みの育成
  /// レベル。
  int levelForOrder(int order, int categoryCorrectCount) {
    final answersPerCharacter = answersPerLevel * maxLevel;
    final ownCorrectCount = categoryCorrectCount - order * answersPerCharacter;
    if (ownCorrectCount <= 0) return 0;
    final level = (ownCorrectCount / answersPerLevel).ceil();
    return level > maxLevel ? maxLevel : level;
  }
}
