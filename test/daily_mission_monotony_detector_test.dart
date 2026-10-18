import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('DailyMissionMonotonyDetector', () {
    const detector = DailyMissionMonotonyDetector(monotonyThreshold: 5);

    test('直近5日が全て同じ種類ならマンネリ化と判定', () {
      final recent = ['arithmetic', 'arithmetic', 'arithmetic', 'arithmetic', 'arithmetic'];
      expect(detector.isMonotonous(recent), isTrue);
    });

    test('直近5日に異なる種類が混ざっていればマンネリ化ではない', () {
      final recent = ['arithmetic', 'arithmetic', 'geometry', 'arithmetic', 'arithmetic'];
      expect(detector.isMonotonous(recent), isFalse);
    });

    test('件数が閾値未満ならマンネリ化と判定しない', () {
      final recent = ['arithmetic', 'arithmetic'];
      expect(detector.isMonotonous(recent), isFalse);
    });
  });
}
