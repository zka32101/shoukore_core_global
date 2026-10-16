import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const notice = EntitlementExpiryNotice(noticeWindow: Duration(days: 3));
  final now = DateTime(2024, 1, 1);

  test('期限まで十分あれば通知しない', () {
    expect(
      notice.shouldNotify(expiresAt: now.add(const Duration(days: 10)), now: now),
      isFalse,
    );
  });

  test('期限まで3日以内なら通知する', () {
    expect(
      notice.shouldNotify(expiresAt: now.add(const Duration(days: 2)), now: now),
      isTrue,
    );
  });

  test('既に失効していれば通知しない（猶予期間側の責務）', () {
    expect(
      notice.shouldNotify(expiresAt: now.subtract(const Duration(days: 1)), now: now),
      isFalse,
    );
  });
}
