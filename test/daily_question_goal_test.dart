import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('DailyQuestionGoal', () {
    const goal = DailyQuestionGoal(targetCount: 10);

    test('目標数以上解いていれば達成', () {
      expect(goal.isAchieved(10), isTrue);
      expect(goal.isAchieved(15), isTrue);
    });

    test('目標数未満なら未達成', () {
      expect(goal.isAchieved(9), isFalse);
    });

    test('残り問題数を正しく算出する', () {
      expect(goal.remainingToGoal(3), 7);
    });

    test('達成済みなら残り問題数は0', () {
      expect(goal.remainingToGoal(12), 0);
    });
  });
}
