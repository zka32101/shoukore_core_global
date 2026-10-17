import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const notice = ProfilePhotoStalenessNotice(stalenessPeriod: Duration(days: 365));
  final now = DateTime(2024, 1, 1);

  test('写真が未設定なら通知しない', () {
    expect(notice.shouldNotify(lastUpdatedAt: null, now: now), isFalse);
  });

  test('更新から1年以内なら通知しない', () {
    expect(
      notice.shouldNotify(lastUpdatedAt: now.subtract(const Duration(days: 100)), now: now),
      isFalse,
    );
  });

  test('更新から1年を超えたら通知する', () {
    expect(
      notice.shouldNotify(lastUpdatedAt: now.subtract(const Duration(days: 400)), now: now),
      isTrue,
    );
  });
}
