/// `CharacterCollectionStore`が読み書きする永続化スナップショット。
/// 「どのキャラを所持しているか」「各キャラの育成レベル」のみを保持する。
/// キャラの一覧・モチーフ・見た目、レベルアップ条件（学習量・コイン等）は
/// 教科・アプリごとに異なるため、本コアは関与しない。
class CharacterCollectionSnapshot {
  const CharacterCollectionSnapshot({this.levelByCharacterId = const {}});

  /// 未保存・初回起動時の既定状態（キャラを1体も所持していない）。
  static const initial = CharacterCollectionSnapshot();

  /// キャラID → 育成レベル。キーに無いキャラは未所持。
  final Map<String, int> levelByCharacterId;

  bool isOwned(String characterId) => levelByCharacterId.containsKey(characterId);

  int get ownedCount => levelByCharacterId.length;

  int levelOf(String characterId) => levelByCharacterId[characterId] ?? 0;
}
