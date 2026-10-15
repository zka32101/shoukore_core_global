import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const pacer = ReviewSessionPacer(
    answerCountThreshold: 20,
    elapsedThreshold: Duration(minutes: 15),
  );

  test('件数・時間ともに閾値未満なら提案しない', () {
    expect(
      pacer.shouldSuggestBreak(
        answeredCount: 10,
        elapsed: const Duration(minutes: 5),
      ),
      isFalse,
    );
  });

  test('解答件数が閾値に達したら提案する', () {
    expect(
      pacer.shouldSuggestBreak(
        answeredCount: 20,
        elapsed: const Duration(minutes: 5),
      ),
      isTrue,
    );
  });

  test('経過時間が閾値に達したら提案する', () {
    expect(
      pacer.shouldSuggestBreak(
        answeredCount: 5,
        elapsed: const Duration(minutes: 15),
      ),
      isTrue,
    );
  });

  test('両方超えても提案する', () {
    expect(
      pacer.shouldSuggestBreak(
        answeredCount: 25,
        elapsed: const Duration(minutes: 20),
      ),
      isTrue,
    );
  });
}
