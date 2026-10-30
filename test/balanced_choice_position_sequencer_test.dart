import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  test('choiceCount回呼ぶと、各位置がちょうど1回ずつ出現する', () {
    final sequencer = BalancedChoicePositionSequencer(random: Random(1));
    final positions = [for (var i = 0; i < 4; i++) sequencer.nextPosition(4)];
    expect(positions.toSet(), {0, 1, 2, 3});
  });

  test('束が尽きるたびに新しい束が作られ、10束分(40回)すべてで各位置が均等に出現する', () {
    final sequencer = BalancedChoicePositionSequencer(random: Random(42));
    final counts = <int, int>{0: 0, 1: 0, 2: 0, 3: 0};
    for (var i = 0; i < 40; i++) {
      final position = sequencer.nextPosition(4);
      counts[position] = counts[position]! + 1;
    }
    for (final count in counts.values) {
      expect(count, 10);
    }
  });

  test('束の境目でも同じ位置が2回連続しすぎない(極端な偏りがない)', () {
    final sequencer = BalancedChoicePositionSequencer(random: Random(7));
    final positions = [for (var i = 0; i < 100; i++) sequencer.nextPosition(3)];
    // 100回中、各位置はおよそ33回程度のはず（均等な束配りのため、大きくは外れない）。
    final counts = <int, int>{0: 0, 1: 0, 2: 0};
    for (final p in positions) {
      counts[p] = (counts[p] ?? 0) + 1;
    }
    for (final count in counts.values) {
      expect(count, greaterThan(20));
      expect(count, lessThan(46));
    }
  });

  test('choiceCountが変わっても、それぞれ独立した束で管理される', () {
    final sequencer = BalancedChoicePositionSequencer(random: Random(3));
    final threeChoice = [for (var i = 0; i < 3; i++) sequencer.nextPosition(3)];
    final fourChoice = [for (var i = 0; i < 4; i++) sequencer.nextPosition(4)];
    expect(threeChoice.toSet(), {0, 1, 2});
    expect(fourChoice.toSet(), {0, 1, 2, 3});
  });
}
