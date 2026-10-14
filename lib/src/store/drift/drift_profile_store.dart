import 'package:drift/drift.dart';

import '../../profile/profile.dart';
import '../../profile/profile_store.dart';
import 'progress_database.dart';

/// `ProfileStore`の既定実装。端末内drift(SQLite)に保存する。
class DriftProfileStore implements ProfileStore {
  DriftProfileStore(this._db);

  static const _activeRowId = 0;

  final ProgressDatabase _db;

  @override
  Future<List<Profile>> listProfiles() async {
    final rows = await _db.select(_db.profiles).get();
    return rows
        .map((r) => Profile(id: r.id, displayName: r.displayName, birthYear: r.birthYear))
        .toList();
  }

  @override
  Future<void> saveProfile(Profile profile) async {
    await _db.into(_db.profiles).insertOnConflictUpdate(
          ProfilesCompanion.insert(
            id: profile.id,
            displayName: profile.displayName,
            birthYear: Value(profile.birthYear),
          ),
        );
  }

  @override
  Future<void> removeProfile(String id) async {
    await (_db.delete(_db.profiles)..where((t) => t.id.equals(id))).go();
    final activeId = await getActiveProfileId();
    if (activeId == id) {
      await setActiveProfileId(null);
    }
  }

  @override
  Future<String?> getActiveProfileId() async {
    final row = await (_db.select(_db.activeProfileState)..where((t) => t.id.equals(_activeRowId)))
        .getSingleOrNull();
    return row?.activeProfileId;
  }

  @override
  Future<void> setActiveProfileId(String? id) async {
    await _db.into(_db.activeProfileState).insertOnConflictUpdate(
          ActiveProfileStateCompanion.insert(
            id: const Value(_activeRowId),
            activeProfileId: Value(id),
          ),
        );
  }

  @override
  Future<void> clearAll() async {
    await _db.delete(_db.profiles).go();
    await (_db.delete(_db.activeProfileState)..where((t) => t.id.equals(_activeRowId))).go();
  }
}
