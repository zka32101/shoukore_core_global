import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('SyncConflictRecurrenceDetector', () {
    const detector = SyncConflictRecurrenceDetector(recurrenceThreshold: 3);

    test('閾値以上のコンフリクト発生回数を持つレコードのみ返す', () {
      final counts = {'record-a': 3, 'record-b': 1, 'record-c': 5};
      expect(detector.findRecurringRecordIds(counts), {'record-a', 'record-c'});
    });

    test('全レコードが閾値未満なら空集合を返す', () {
      final counts = {'record-a': 1, 'record-b': 2};
      expect(detector.findRecurringRecordIds(counts), isEmpty);
    });

    test('空のマップなら空集合を返す', () {
      expect(detector.findRecurringRecordIds(const {}), isEmpty);
    });
  });
}
