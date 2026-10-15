import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('日をまたがない範囲（13:00〜15:00）', () {
    final merge = NotificationQuietMerge(
      const QuietHoursGuard(
        start: TimeOfDay(hour: 13, minute: 0),
        end: TimeOfDay(hour: 15, minute: 0),
      ),
    );

    test('静かな時間帯外はそのまま返す', () {
      final scheduledAt = DateTime(2024, 1, 1, 10, 0);
      expect(merge.resolve(scheduledAt), scheduledAt);
    });

    test('静かな時間帯内なら終了時刻に変更する', () {
      final scheduledAt = DateTime(2024, 1, 1, 14, 0);
      expect(merge.resolve(scheduledAt), DateTime(2024, 1, 1, 15, 0));
    });
  });

  group('日をまたぐ範囲（21:00〜翌7:00）', () {
    final merge = NotificationQuietMerge(
      const QuietHoursGuard(
        start: TimeOfDay(hour: 21, minute: 0),
        end: TimeOfDay(hour: 7, minute: 0),
      ),
    );

    test('夜間なら翌朝の終了時刻に変更する', () {
      final scheduledAt = DateTime(2024, 1, 1, 23, 0);
      expect(merge.resolve(scheduledAt), DateTime(2024, 1, 2, 7, 0));
    });

    test('深夜0時台なら同日の終了時刻に変更する', () {
      final scheduledAt = DateTime(2024, 1, 2, 2, 0);
      expect(merge.resolve(scheduledAt), DateTime(2024, 1, 2, 7, 0));
    });

    test('昼間はそのまま返す', () {
      final scheduledAt = DateTime(2024, 1, 1, 12, 0);
      expect(merge.resolve(scheduledAt), scheduledAt);
    });
  });
}
