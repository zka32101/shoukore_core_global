import '../migration_ledger.dart';
import 'progress_database.dart';

/// `MigrationLedger`の既定実装。端末内drift(SQLite)に保存する。
class DriftMigrationLedger implements MigrationLedger {
  DriftMigrationLedger(this._db);

  final ProgressDatabase _db;

  @override
  Future<bool> isApplied(String migrationId) async {
    final row = await (_db.select(_db.appliedMigrations)
          ..where((t) => t.migrationId.equals(migrationId)))
        .getSingleOrNull();
    return row != null;
  }

  @override
  Future<void> markApplied(String migrationId) async {
    await _db.into(_db.appliedMigrations).insertOnConflictUpdate(
          AppliedMigrationsCompanion.insert(migrationId: migrationId),
        );
  }

  @override
  Future<void> clearAll() async {
    await _db.delete(_db.appliedMigrations).go();
  }
}
