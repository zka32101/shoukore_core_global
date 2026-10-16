import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const detector = OfflineSessionGapDetector(gapThreshold: Duration(days: 3));

  test('初回起動（lastSessionEndedAtがnull）なら長時間ギャップではない', () {
    expect(
      detector.isLongGap(lastSessionEndedAt: null, now: DateTime(2024, 1, 1)),
      isFalse,
    );
  });

  test('間隔が閾値未満なら長時間ギャップではない', () {
    expect(
      detector.isLongGap(
        lastSessionEndedAt: DateTime(2024, 1, 1),
        now: DateTime(2024, 1, 2),
      ),
      isFalse,
    );
  });

  test('間隔が閾値以上なら長時間ギャップと判定する', () {
    expect(
      detector.isLongGap(
        lastSessionEndedAt: DateTime(2024, 1, 1),
        now: DateTime(2024, 1, 5),
      ),
      isTrue,
    );
  });
}
