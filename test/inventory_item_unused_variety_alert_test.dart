import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('InventoryItemUnusedVarietyAlert', () {
    test('未使用アイテムの種類数が閾値以上であればアラートすべきと判定する', () {
      const alert = InventoryItemUnusedVarietyAlert(unusedVarietyThreshold: 2);

      final result = alert.shouldAlert({
        'a': null,
        'b': null,
        'c': DateTime(2026, 1, 1),
      });

      expect(result, isTrue);
    });

    test('未使用アイテムの種類数が閾値未満であればアラート不要と判定する', () {
      const alert = InventoryItemUnusedVarietyAlert(unusedVarietyThreshold: 3);

      final result = alert.shouldAlert({
        'a': null,
        'b': DateTime(2026, 1, 1),
      });

      expect(result, isFalse);
    });

    test('未使用アイテムIDの一覧を返す', () {
      const alert = InventoryItemUnusedVarietyAlert();

      final result = alert.findUnusedItemIds({
        'a': null,
        'b': DateTime(2026, 1, 1),
        'c': null,
      });

      expect(result, ['a', 'c']);
    });
  });
}
