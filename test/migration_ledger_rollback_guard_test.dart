import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const guard = MigrationLedgerRollbackGuard();

  test('適用済みIDが既知のIDに全て含まれていれば異常なし', () {
    expect(
      guard.hasUnknownAppliedMigrations(
        appliedMigrationIds: const {'m1', 'm2'},
        knownMigrationIds: const {'m1', 'm2', 'm3'},
      ),
      isFalse,
    );
  });

  test('適用済みIDが空なら異常なし', () {
    expect(
      guard.hasUnknownAppliedMigrations(
        appliedMigrationIds: const {},
        knownMigrationIds: const {'m1'},
      ),
      isFalse,
    );
  });

  test('既知のIDにない適用済みIDがあれば異常と判定する', () {
    expect(
      guard.hasUnknownAppliedMigrations(
        appliedMigrationIds: const {'m1', 'm9'},
        knownMigrationIds: const {'m1', 'm2'},
      ),
      isTrue,
    );
  });
}
