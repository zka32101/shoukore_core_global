import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const throttle = DataExportRequestThrottle(minInterval: Duration(hours: 24));

  test('一度も要求していない場合は常に許可する', () {
    expect(
      throttle.shouldThrottle(lastRequestedAt: null, now: DateTime(2024, 1, 1)),
      isFalse,
    );
  });

  test('最小間隔未満の再要求は遅延させる', () {
    expect(
      throttle.shouldThrottle(
        lastRequestedAt: DateTime(2024, 1, 1),
        now: DateTime(2024, 1, 1, 12),
      ),
      isTrue,
    );
  });

  test('最小間隔以上なら許可する', () {
    expect(
      throttle.shouldThrottle(
        lastRequestedAt: DateTime(2024, 1, 1),
        now: DateTime(2024, 1, 2),
      ),
      isFalse,
    );
  });

  test('nextAllowedAtはlastRequestedAt+minIntervalを返す', () {
    expect(
      throttle.nextAllowedAt(DateTime(2024, 1, 1)),
      DateTime(2024, 1, 2),
    );
  });

  test('lastRequestedAtがnullならnextAllowedAtもnull', () {
    expect(throttle.nextAllowedAt(null), isNull);
  });
}
