import 'character_collection_snapshot.dart';

/// キャラクターコレクション（所持キャラ・育成レベル）の保存先を抽象化する。
/// `GrowthStore`/`InventoryStore`と同様、永続化先はアプリ側が選ぶ。
abstract class CharacterCollectionStore {
  Future<CharacterCollectionSnapshot> load();

  Future<void> save(CharacterCollectionSnapshot snapshot);

  /// 保護者からのデータ削除要求（LGPD/ECA Digital対応）に応じて全記録を消去する。
  Future<void> clearAll();
}
