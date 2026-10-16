import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const detector = GuardianGateRapidAttemptDetector(
    minimumPlausibleInterval: Duration(seconds: 2),
  );

  test('初回試行（previousAttemptAtがnull）は警戒しない', () {
    expect(
      detector.isSuspicious(previousAttemptAt: null, now: DateTime(2024, 1, 1, 0, 0, 5)),
      isFalse,
    );
  });

  test('十分な間隔が空いていれば警戒しない', () {
    expect(
      detector.isSuspicious(
        previousAttemptAt: DateTime(2024, 1, 1, 0, 0, 0),
        now: DateTime(2024, 1, 1, 0, 0, 5),
      ),
      isFalse,
    );
  });

  test('異常に短い間隔での連続試行は警戒する', () {
    expect(
      detector.isSuspicious(
        previousAttemptAt: DateTime(2024, 1, 1, 0, 0, 0),
        now: DateTime(2024, 1, 1, 0, 0, 0, 500),
      ),
      isTrue,
    );
  });
}
