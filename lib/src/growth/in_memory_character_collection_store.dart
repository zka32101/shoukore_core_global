import 'character_collection_snapshot.dart';
import 'character_collection_store.dart';

/// `CharacterCollectionStore`の端末内メモリ実装。テスト・プロトタイピング用途、
/// または永続化が不要な軽量アプリ向け。
class InMemoryCharacterCollectionStore implements CharacterCollectionStore {
  CharacterCollectionSnapshot _snapshot = CharacterCollectionSnapshot.initial;

  @override
  Future<CharacterCollectionSnapshot> load() async => _snapshot;

  @override
  Future<void> save(CharacterCollectionSnapshot snapshot) async {
    _snapshot = snapshot;
  }

  @override
  Future<void> clearAll() async {
    _snapshot = CharacterCollectionSnapshot.initial;
  }
}
