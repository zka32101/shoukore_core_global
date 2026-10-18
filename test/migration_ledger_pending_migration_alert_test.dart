import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('MigrationLedgerPendingMigrationAlert', () {
    test('認識しているが未適用のIDがあれば検出する', () {
      const alert = MigrationLedgerPendingMigrationAlert();

      final result = alert.findPendingMigrationIds(
        knownMigrationIds: {'m1', 'm2', 'm3'},
        appliedMigrationIds: {'m1', 'm2'},
      );

      expect(result, {'m3'});
    });

    test('全て適用済みであれば未適用なしと判定する', () {
      const alert = MigrationLedgerPendingMigrationAlert();

      final result = alert.hasPendingMigrations(
        knownMigrationIds: {'m1', 'm2'},
        appliedMigrationIds: {'m1', 'm2'},
      );

      expect(result, isFalse);
    });

    test('未適用のIDが1件以上あればtrueを返す', () {
      const alert = MigrationLedgerPendingMigrationAlert();

      final result = alert.hasPendingMigrations(
        knownMigrationIds: {'m1'},
        appliedMigrationIds: {},
      );

      expect(result, isTrue);
    });
  });
}
