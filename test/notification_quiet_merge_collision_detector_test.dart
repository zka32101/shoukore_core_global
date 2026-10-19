import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('NotificationQuietMergeCollisionDetector', () {
    const detector = NotificationQuietMergeCollisionDetector(collisionThreshold: 3);

    test('同一時刻への解決が閾値以上なら衝突と判定', () {
      final at = DateTime(2024, 1, 1, 7, 0);
      final resolved = [at, at, at];
      expect(detector.hasCollision(resolved), isTrue);
    });

    test('解決時刻が分散していれば衝突ではない', () {
      final resolved = [
        DateTime(2024, 1, 1, 7, 0),
        DateTime(2024, 1, 1, 8, 0),
        DateTime(2024, 1, 1, 9, 0),
      ];
      expect(detector.hasCollision(resolved), isFalse);
    });

    test('空リストなら衝突ではない', () {
      expect(detector.hasCollision(const []), isFalse);
    });
  });
}
