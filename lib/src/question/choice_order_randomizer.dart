import 'dart:math';

/// クイズの選択肢の表示順をランダムに並び替える純関数。正解の位置を
/// 毎回変えることで、位置の記憶による不正解率低下を防ぐ。実際の
/// 選択肢の描画自体はアプリ側の責務とする。
class ChoiceOrderRandomizer {
  ChoiceOrderRandomizer({Random? random}) : _random = random ?? Random();

  final Random _random;

  /// [choices]をランダムな順序に並び替えた新しいリストを返す。
  /// 元のリストは変更しない。
  List<T> shuffle<T>(List<T> choices) {
    final shuffled = List<T>.of(choices);
    shuffled.shuffle(_random);
    return shuffled;
  }
}
