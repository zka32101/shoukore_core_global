import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';
import 'package:shoukore_core_global/shoukore_core_global_drift.dart';

/// `ProfileStore`の実装はいずれも同じ契約を満たす必要がある。
/// 新しい実装を追加したら、この関数を呼ぶテストを追加すること。
void runProfileStoreContractTests(
  String label,
  ProfileStore Function() createStore, {
  void Function()? disposeStore,
}) {
  group(label, () {
    late ProfileStore store;

    setUp(() => store = createStore());

    if (disposeStore != null) {
      tearDown(disposeStore);
    }

    test('未保存状態では空のプロファイル一覧・activeProfileIdはnull', () async {
      expect(await store.listProfiles(), isEmpty);
      expect(await store.getActiveProfileId(), isNull);
    });

    test('saveProfileで追加した内容をlistProfilesで復元できる', () async {
      await store.saveProfile(const Profile(id: 'p1', displayName: 'たろう', birthYear: 2018));

      final profiles = await store.listProfiles();
      expect(profiles, hasLength(1));
      expect(profiles.first.id, 'p1');
      expect(profiles.first.displayName, 'たろう');
      expect(profiles.first.birthYear, 2018);
    });

    test('同じidでsaveProfileすると上書きされる', () async {
      await store.saveProfile(const Profile(id: 'p1', displayName: 'たろう'));
      await store.saveProfile(const Profile(id: 'p1', displayName: 'たろう（改名）'));

      final profiles = await store.listProfiles();
      expect(profiles, hasLength(1));
      expect(profiles.first.displayName, 'たろう（改名）');
    });

    test('removeProfileで削除できる', () async {
      await store.saveProfile(const Profile(id: 'p1', displayName: 'たろう'));
      await store.saveProfile(const Profile(id: 'p2', displayName: 'はなこ'));
      await store.removeProfile('p1');

      final profiles = await store.listProfiles();
      expect(profiles.map((p) => p.id), ['p2']);
    });

    test('setActiveProfileId/getActiveProfileIdで選択状態を管理できる', () async {
      await store.saveProfile(const Profile(id: 'p1', displayName: 'たろう'));
      await store.setActiveProfileId('p1');

      expect(await store.getActiveProfileId(), 'p1');
    });

    test('アクティブなプロファイルをremoveProfileすると選択状態もnullになる', () async {
      await store.saveProfile(const Profile(id: 'p1', displayName: 'たろう'));
      await store.setActiveProfileId('p1');
      await store.removeProfile('p1');

      expect(await store.getActiveProfileId(), isNull);
    });

    test('clearAllで全プロファイルと選択状態が消える（保護者のデータ削除要求対応）', () async {
      await store.saveProfile(const Profile(id: 'p1', displayName: 'たろう'));
      await store.setActiveProfileId('p1');
      await store.clearAll();

      expect(await store.listProfiles(), isEmpty);
      expect(await store.getActiveProfileId(), isNull);
    });
  });
}

void main() {
  runProfileStoreContractTests(
    'InMemoryProfileStore',
    () => InMemoryProfileStore(),
  );

  ProgressDatabase? currentDb;
  runProfileStoreContractTests(
    'DriftProfileStore',
    () {
      final db = ProgressDatabase(NativeDatabase.memory());
      currentDb = db;
      return DriftProfileStore(db);
    },
    disposeStore: () => currentDb?.close(),
  );
}
