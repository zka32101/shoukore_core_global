import 'migration_ledger.dart';

/// `MigrationLedger`の端末内メモリ実装。テスト・プロトタイピング用途、または
/// 永続化が不要な軽量アプリ向け。既定実装は`DriftMigrationLedger`（端末内drift）で、
/// 本実装は同じ契約を満たす（`test/migration_ledger_contract_test.dart`参照）。
class InMemoryMigrationLedger implements MigrationLedger {
  final Set<String> _appliedMigrationIds = {};

  @override
  Future<bool> isApplied(String migrationId) async => _appliedMigrationIds.contains(migrationId);

  @override
  Future<void> markApplied(String migrationId) async {
    _appliedMigrationIds.add(migrationId);
  }

  @override
  Future<void> clearAll() async {
    _appliedMigrationIds.clear();
  }
}
