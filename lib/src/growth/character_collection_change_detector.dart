import 'character_collection_snapshot.dart';

/// 2つの`CharacterCollectionSnapshot`を比較し、新たに所持した・レベルアップ
/// したキャラを検出する純関数。「集める楽しみ」の達成演出（新規解除・
/// レベルアップのお祝い表示）のトリガーに使う。演出自体・文言はアプリ側の責務。
class CharacterCollectionChangeDetector {
  const CharacterCollectionChangeDetector();

  /// [before]から[after]への変化で、新たに所持した（未所持→所持）キャラID一覧。
  Set<String> newlyOwned({
    required CharacterCollectionSnapshot before,
    required CharacterCollectionSnapshot after,
  }) {
    return after.levelByCharacterId.keys.where((id) => !before.isOwned(id)).toSet();
  }

  /// [before]から[after]への変化でレベルが上がったキャラID→新レベルのMap
  /// （新規所持によるLv0→1の変化も含む）。
  Map<String, int> leveledUp({
    required CharacterCollectionSnapshot before,
    required CharacterCollectionSnapshot after,
  }) {
    final result = <String, int>{};
    for (final entry in after.levelByCharacterId.entries) {
      final beforeLevel = before.levelOf(entry.key);
      if (entry.value > beforeLevel) {
        result[entry.key] = entry.value;
      }
    }
    return result;
  }
}
