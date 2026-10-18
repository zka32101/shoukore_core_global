import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('WeakNoteBacklogSizeAlert', () {
    const alert = WeakNoteBacklogSizeAlert(backlogThreshold: 2);

    WeakNote weak(String unitId) =>
        WeakNote(unitId: unitId, misconceptionCounts: const {'typeA': 1});

    WeakNote resolved(String unitId) =>
        WeakNote(unitId: unitId, misconceptionCounts: const {});

    test('未解消のノート件数が閾値以上なら積み上がりと判定', () {
      final notes = [weak('u1'), weak('u2')];
      expect(alert.isBacklogged(notes), isTrue);
    });

    test('解消済みノートは件数に含めない', () {
      final notes = [weak('u1'), resolved('u2')];
      expect(alert.isBacklogged(notes), isFalse);
    });

    test('件数が閾値未満なら積み上がりではない', () {
      final notes = [weak('u1')];
      expect(alert.isBacklogged(notes), isFalse);
    });
  });
}
