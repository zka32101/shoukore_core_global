import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const notice = SettingsBackupStalenessNotice(stalenessPeriod: Duration(days: 90));
  final now = DateTime(2024, 1, 1);

  test('一度もバックアップしていなければ通知する', () {
    expect(notice.shouldNotify(lastBackedUpAt: null, now: now), isTrue);
  });

  test('最近バックアップしていれば通知しない', () {
    expect(
      notice.shouldNotify(lastBackedUpAt: now.subtract(const Duration(days: 10)), now: now),
      isFalse,
    );
  });

  test('長期間バックアップしていなければ通知する', () {
    expect(
      notice.shouldNotify(lastBackedUpAt: now.subtract(const Duration(days: 100)), now: now),
      isTrue,
    );
  });
}
