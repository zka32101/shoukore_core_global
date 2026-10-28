import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const tracker = AhaMomentTracker();

  test('未到達かつ正解なら新規到達と判定する', () {
    final reached = tracker.reachedOnThisAnswer(alreadyReached: false, correct: true);
    expect(reached, isTrue);
  });

  test('未到達かつ不正解なら到達と判定しない', () {
    final reached = tracker.reachedOnThisAnswer(alreadyReached: false, correct: false);
    expect(reached, isFalse);
  });

  test('既に到達済みなら正解でも重複して到達と判定しない', () {
    final reached = tracker.reachedOnThisAnswer(alreadyReached: true, correct: true);
    expect(reached, isFalse);
  });

  test('既に到達済みで不正解でも到達と判定しない', () {
    final reached = tracker.reachedOnThisAnswer(alreadyReached: true, correct: false);
    expect(reached, isFalse);
  });
}
