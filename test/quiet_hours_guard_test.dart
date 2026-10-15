import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('QuietHoursGuard（日をまたがない範囲）', () {
    const guard = QuietHoursGuard(
      start: TimeOfDay(hour: 13, minute: 0),
      end: TimeOfDay(hour: 15, minute: 0),
    );

    test('範囲内はtrue', () {
      expect(guard.isQuietAt(DateTime(2024, 1, 1, 14, 0)), isTrue);
    });

    test('開始時刻ちょうどはtrue', () {
      expect(guard.isQuietAt(DateTime(2024, 1, 1, 13, 0)), isTrue);
    });

    test('終了時刻ちょうどはfalse（終了は含まない）', () {
      expect(guard.isQuietAt(DateTime(2024, 1, 1, 15, 0)), isFalse);
    });

    test('範囲外はfalse', () {
      expect(guard.isQuietAt(DateTime(2024, 1, 1, 10, 0)), isFalse);
    });
  });

  group('QuietHoursGuard（日をまたぐ範囲、21:00〜翌7:00）', () {
    const guard = QuietHoursGuard(
      start: TimeOfDay(hour: 21, minute: 0),
      end: TimeOfDay(hour: 7, minute: 0),
    );

    test('深夜0時はtrue', () {
      expect(guard.isQuietAt(DateTime(2024, 1, 1, 0, 30)), isTrue);
    });

    test('夜22時はtrue', () {
      expect(guard.isQuietAt(DateTime(2024, 1, 1, 22, 0)), isTrue);
    });

    test('朝7時はfalse（終了は含まない）', () {
      expect(guard.isQuietAt(DateTime(2024, 1, 1, 7, 0)), isFalse);
    });

    test('昼間はfalse', () {
      expect(guard.isQuietAt(DateTime(2024, 1, 1, 12, 0)), isFalse);
    });
  });

  test('startとendが同一ならどの時刻でもfalse', () {
    const guard = QuietHoursGuard(
      start: TimeOfDay(hour: 9, minute: 0),
      end: TimeOfDay(hour: 9, minute: 0),
    );
    expect(guard.isQuietAt(DateTime(2024, 1, 1, 9, 0)), isFalse);
    expect(guard.isQuietAt(DateTime(2024, 1, 1, 23, 59)), isFalse);
  });
}
