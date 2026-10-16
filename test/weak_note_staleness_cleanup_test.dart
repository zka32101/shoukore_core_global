import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const cleanup = WeakNoteStalenessCleanup(staleAfter: Duration(days: 90));

  test('弱点がなければ整理対象にしない', () {
    const note = WeakNote(unitId: 'u1', misconceptionCounts: {});
    expect(
      cleanup.shouldCleanUp(
        note: note,
        lastUpdatedAt: DateTime(2024, 1, 1),
        now: DateTime(2024, 6, 1),
      ),
      isFalse,
    );
  });

  test('弱点があり更新から十分日数が経っていなければ整理しない', () {
    const note = WeakNote(unitId: 'u1', misconceptionCounts: {'a': 3});
    expect(
      cleanup.shouldCleanUp(
        note: note,
        lastUpdatedAt: DateTime(2024, 1, 1),
        now: DateTime(2024, 1, 10),
      ),
      isFalse,
    );
  });

  test('弱点があり更新から長期間経っていれば整理対象とする', () {
    const note = WeakNote(unitId: 'u1', misconceptionCounts: {'a': 3});
    expect(
      cleanup.shouldCleanUp(
        note: note,
        lastUpdatedAt: DateTime(2024, 1, 1),
        now: DateTime(2024, 6, 1),
      ),
      isTrue,
    );
  });
}
