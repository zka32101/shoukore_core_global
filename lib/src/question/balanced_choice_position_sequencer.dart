import 'dart:math';

/// 正解の選択肢を置く位置(0-indexed)を、短い区間でも偏りなく決める純粋な
/// 状態付きクラス。単純な`Random.nextInt`だけに任せると、短い区間
/// (例えば連続10問)では同じ位置に正解が何度も偏ることがある
/// (CLAUDE.md共通要件「選択肢はランダムに」はランダム性だけでなく、
/// 実際に遊んだときの「バランスの良さ」も含む)。
///
/// トランプを配るときのように、[choiceCount]個の位置を1回ずつ含む
/// 「束(bag)」をシャッフルしてから1つずつ取り出し、尽きたら新しい束を
/// 作り直す("shuffle bag"方式)。これにより、各[choiceCount]回の出題
/// ごとに全位置が必ず1回ずつ使われることが保証されつつ、順序自体は
/// ランダムなままになる。束の境目で同じ位置が連続しないよう、新しい束の
/// 先頭が前の束の末尾と同じ場合は入れ替える。
class BalancedChoicePositionSequencer {
  BalancedChoicePositionSequencer({Random? random}) : _random = random ?? Random();

  final Random _random;
  final Map<int, List<int>> _bagsByChoiceCount = {};
  int? _lastPosition;

  /// [choiceCount]個の選択肢の中で、正解を置くべき位置(0-indexed)を返す。
  int nextPosition(int choiceCount) {
    if (choiceCount <= 0) return 0;

    var bag = _bagsByChoiceCount[choiceCount];
    if (bag == null || bag.isEmpty) {
      bag = List.generate(choiceCount, (i) => i)..shuffle(_random);
      if (bag.length > 1 && bag.first == _lastPosition) {
        final swapIndex = 1 + _random.nextInt(bag.length - 1);
        final first = bag[0];
        bag[0] = bag[swapIndex];
        bag[swapIndex] = first;
      }
      _bagsByChoiceCount[choiceCount] = bag;
    }

    final position = bag.removeAt(0);
    _lastPosition = position;
    return position;
  }
}
