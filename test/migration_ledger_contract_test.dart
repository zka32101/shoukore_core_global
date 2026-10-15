import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';
import 'package:shoukore_core_global/shoukore_core_global_drift.dart';

/// `MigrationLedger`の実装はいずれも同じ契約を満たす必要がある。
/// 新しい実装を追加したら、この関数を呼ぶテストを追加すること。
void runMigrationLedgerContractTests(
  String label,
  MigrationLedger Function() createLedger, {
  void Function()? disposeLedger,
}) {
  group(label, () {
    late MigrationLedger ledger;

    setUp(() => ledger = createLedger());

    if (disposeLedger != null) {
      tearDown(disposeLedger);
    }

    test('未記録のmigrationIdはfalse', () async {
      expect(await ledger.isApplied('legacy_profile_migration'), isFalse);
    });

    test('markAppliedした内容はisAppliedでtrueになる', () async {
      await ledger.markApplied('legacy_profile_migration');

      expect(await ledger.isApplied('legacy_profile_migration'), isTrue);
    });

    test('異なるmigrationIdは互いに影響しない', () async {
      await ledger.markApplied('legacy_profile_migration');

      expect(await ledger.isApplied('other_migration'), isFalse);
    });

    test('同じmigrationIdに再度markAppliedしてもエラーにならない', () async {
      await ledger.markApplied('legacy_profile_migration');
      await ledger.markApplied('legacy_profile_migration');

      expect(await ledger.isApplied('legacy_profile_migration'), isTrue);
    });

    test('clearAllで全件消える（保護者のデータ削除要求対応）', () async {
      await ledger.markApplied('legacy_profile_migration');
      await ledger.clearAll();

      expect(await ledger.isApplied('legacy_profile_migration'), isFalse);
    });
  });
}

void main() {
  runMigrationLedgerContractTests(
    'InMemoryMigrationLedger',
    () => InMemoryMigrationLedger(),
  );

  ProgressDatabase? currentDb;
  runMigrationLedgerContractTests(
    'DriftMigrationLedger',
    () {
      final db = ProgressDatabase(NativeDatabase.memory());
      currentDb = db;
      return DriftMigrationLedger(db);
    },
    disposeLedger: () => currentDb?.close(),
  );
}
