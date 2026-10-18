import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('SyncConflictResolutionUndoWindow', () {
    test('解決から一定時間以内であれば取り消しを許可する', () {
      const window = SyncConflictResolutionUndoWindow(undoWindow: Duration(minutes: 5));
      final resolvedAt = DateTime(2026, 1, 1, 12, 0);
      final now = resolvedAt.add(const Duration(minutes: 2));

      expect(window.canUndo(resolvedAt: resolvedAt, now: now), isTrue);
    });

    test('解決から一定時間を超えていれば取り消しを許可しない', () {
      const window = SyncConflictResolutionUndoWindow(undoWindow: Duration(minutes: 5));
      final resolvedAt = DateTime(2026, 1, 1, 12, 0);
      final now = resolvedAt.add(const Duration(minutes: 10));

      expect(window.canUndo(resolvedAt: resolvedAt, now: now), isFalse);
    });

    test('ちょうど境界の時間は取り消しを許可する', () {
      const window = SyncConflictResolutionUndoWindow(undoWindow: Duration(minutes: 5));
      final resolvedAt = DateTime(2026, 1, 1, 12, 0);
      final now = resolvedAt.add(const Duration(minutes: 5));

      expect(window.canUndo(resolvedAt: resolvedAt, now: now), isTrue);
    });
  });
}
