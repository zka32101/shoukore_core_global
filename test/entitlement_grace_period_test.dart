import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const grace = EntitlementGracePeriod(graceDuration: Duration(days: 3));

  test('失効直後は猶予期間中', () {
    final expiredAt = DateTime(2024, 1, 1);
    expect(
      grace.isWithinGrace(expiredAt: expiredAt, now: DateTime(2024, 1, 1, 1)),
      isTrue,
    );
  });

  test('猶予期間内なら利用可能', () {
    final expiredAt = DateTime(2024, 1, 1);
    expect(
      grace.isWithinGrace(expiredAt: expiredAt, now: DateTime(2024, 1, 3)),
      isTrue,
    );
  });

  test('猶予期間を過ぎたら利用不可', () {
    final expiredAt = DateTime(2024, 1, 1);
    expect(
      grace.isWithinGrace(expiredAt: expiredAt, now: DateTime(2024, 1, 5)),
      isFalse,
    );
  });

  test('graceEndsAtは失効時刻+猶予期間', () {
    final expiredAt = DateTime(2024, 1, 1);
    expect(grace.graceEndsAt(expiredAt), DateTime(2024, 1, 4));
  });
}
