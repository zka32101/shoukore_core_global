import 'profile.dart';
import 'profile_store.dart';

/// `ProfileStore`の端末内メモリ実装。テスト・プロトタイピング用途、または
/// 永続化が不要な軽量アプリ向け。既定実装は`DriftProfileStore`（端末内drift）で、
/// 本実装は同じ契約を満たす（`test/profile_store_contract_test.dart`参照）。
class InMemoryProfileStore implements ProfileStore {
  final Map<String, Profile> _profiles = {};
  String? _activeProfileId;

  @override
  Future<List<Profile>> listProfiles() async => _profiles.values.toList();

  @override
  Future<void> saveProfile(Profile profile) async {
    _profiles[profile.id] = profile;
  }

  @override
  Future<void> removeProfile(String id) async {
    _profiles.remove(id);
    if (_activeProfileId == id) {
      _activeProfileId = null;
    }
  }

  @override
  Future<String?> getActiveProfileId() async => _activeProfileId;

  @override
  Future<void> setActiveProfileId(String? id) async {
    _activeProfileId = id;
  }

  @override
  Future<void> clearAll() async {
    _profiles.clear();
    _activeProfileId = null;
  }
}
