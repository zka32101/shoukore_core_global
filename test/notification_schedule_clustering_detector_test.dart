import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('NotificationScheduleClusteringDetector', () {
    test('短時間に閾値以上の通知が密集していればクラスターと判定する', () {
      const detector = NotificationScheduleClusteringDetector(
        clusterWindow: Duration(minutes: 10),
        clusterThreshold: 3,
      );
      final base = DateTime(2026, 1, 1, 9, 0);

      final scheduled = [
        NotificationScheduleEntry(id: 'a', at: base, titleKey: 't1', bodyKey: 'b1'),
        NotificationScheduleEntry(
          id: 'b',
          at: base.add(const Duration(minutes: 3)),
          titleKey: 't2',
          bodyKey: 'b2',
        ),
        NotificationScheduleEntry(
          id: 'c',
          at: base.add(const Duration(minutes: 6)),
          titleKey: 't3',
          bodyKey: 'b3',
        ),
      ];

      expect(detector.isClustered(scheduled), isTrue);
    });

    test('時間がばらけていればクラスターと判定しない', () {
      const detector = NotificationScheduleClusteringDetector(
        clusterWindow: Duration(minutes: 10),
        clusterThreshold: 3,
      );
      final base = DateTime(2026, 1, 1, 9, 0);

      final scheduled = [
        NotificationScheduleEntry(id: 'a', at: base, titleKey: 't1', bodyKey: 'b1'),
        NotificationScheduleEntry(
          id: 'b',
          at: base.add(const Duration(hours: 1)),
          titleKey: 't2',
          bodyKey: 'b2',
        ),
        NotificationScheduleEntry(
          id: 'c',
          at: base.add(const Duration(hours: 2)),
          titleKey: 't3',
          bodyKey: 'b3',
        ),
      ];

      expect(detector.isClustered(scheduled), isFalse);
    });

    test('通知件数が閾値未満であればクラスターと判定しない', () {
      const detector = NotificationScheduleClusteringDetector(clusterThreshold: 3);
      final base = DateTime(2026, 1, 1, 9, 0);

      final scheduled = [
        NotificationScheduleEntry(id: 'a', at: base, titleKey: 't1', bodyKey: 'b1'),
      ];

      expect(detector.isClustered(scheduled), isFalse);
    });
  });
}
