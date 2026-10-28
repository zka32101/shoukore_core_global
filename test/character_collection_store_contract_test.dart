import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

/// `CharacterCollectionStore`の実装はいずれも同じ契約を満たす必要がある。
/// 新しい実装を追加したら、この関数を呼ぶテストを追加すること。
void runCharacterCollectionStoreContractTests(
  String label,
  CharacterCollectionStore Function() createStore,
) {
  group(label, () {
    late CharacterCollectionStore store;

    setUp(() => store = createStore());

    test('未保存状態では何も所持していないスナップショットを返す', () async {
      final snapshot = await store.load();
      expect(snapshot.ownedCount, 0);
      expect(snapshot.isOwned('onça'), isFalse);
      expect(snapshot.levelOf('onça'), 0);
    });

    test('saveした内容をloadで復元できる', () async {
      await store.save(const CharacterCollectionSnapshot(levelByCharacterId: {'onça': 2}));

      final snapshot = await store.load();
      expect(snapshot.isOwned('onça'), isTrue);
      expect(snapshot.levelOf('onça'), 2);
      expect(snapshot.ownedCount, 1);
    });

    test('saveを繰り返すと最新の内容で上書きされる', () async {
      await store.save(const CharacterCollectionSnapshot(levelByCharacterId: {'onça': 1}));
      await store.save(const CharacterCollectionSnapshot(
        levelByCharacterId: {'onça': 3, 'capivara': 1},
      ));

      final snapshot = await store.load();
      expect(snapshot.levelOf('onça'), 3);
      expect(snapshot.ownedCount, 2);
    });

    test('clearAllで未所持状態に戻る（保護者のデータ削除要求対応）', () async {
      await store.save(const CharacterCollectionSnapshot(levelByCharacterId: {'onça': 2}));
      await store.clearAll();

      final snapshot = await store.load();
      expect(snapshot.ownedCount, 0);
    });
  });
}

void main() {
  runCharacterCollectionStoreContractTests(
    'InMemoryCharacterCollectionStore',
    () => InMemoryCharacterCollectionStore(),
  );
}
