import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('SettingsBackupRestoreFailureStreak', () {
    const streak = SettingsBackupRestoreFailureStreak(failureThreshold: 3);

    test('連続失敗回数が閾値以上なら連続失敗と判定', () {
      expect(streak.isPersistentlyFailing(3), isTrue);
      expect(streak.isPersistentlyFailing(5), isTrue);
    });

    test('連続失敗回数が閾値未満なら連続失敗ではない', () {
      expect(streak.isPersistentlyFailing(2), isFalse);
    });

    test('連続失敗回数が0なら連続失敗ではない', () {
      expect(streak.isPersistentlyFailing(0), isFalse);
    });
  });
}
