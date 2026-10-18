import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('WeakNoteMisconceptionDiversityAlert', () {
    test('誤解タイプの種類数が閾値以上であれば多様化していると判定する', () {
      const alert = WeakNoteMisconceptionDiversityAlert(diversityThreshold: 2);
      const note = WeakNote(
        unitId: 'unit1',
        misconceptionCounts: {'carry_error': 3, 'sign_error': 1},
      );

      expect(alert.isDiverse(note), isTrue);
    });

    test('誤解タイプの種類数が閾値未満であれば多様化していないと判定する', () {
      const alert = WeakNoteMisconceptionDiversityAlert(diversityThreshold: 3);
      const note = WeakNote(
        unitId: 'unit1',
        misconceptionCounts: {'carry_error': 3, 'sign_error': 1},
      );

      expect(alert.isDiverse(note), isFalse);
    });

    test('誤解タイプが空であれば多様化していないと判定する', () {
      const alert = WeakNoteMisconceptionDiversityAlert();
      const note = WeakNote(unitId: 'unit1', misconceptionCounts: {});

      expect(alert.isDiverse(note), isFalse);
    });
  });
}
