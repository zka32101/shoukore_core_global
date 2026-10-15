import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

Attempt _attempt(bool correct) => Attempt(
      questionId: 'q',
      unitId: 'u1',
      correct: correct,
      answeredAt: DateTime(2024, 1, 1),
    );

void main() {
  const eligibility = UnitMasteryBadgeEligibility(
    requiredAttempts: 10,
    requiredAccuracy: 0.9,
  );

  test('件数が足りない場合はマスター未達', () {
    final attempts = List.generate(5, (_) => _attempt(true));
    expect(eligibility.isMastered(attempts), isFalse);
  });

  test('正答率が閾値未満ならマスター未達', () {
    final attempts = [
      ...List.generate(8, (_) => _attempt(true)),
      ...List.generate(2, (_) => _attempt(false)),
    ];
    expect(eligibility.isMastered(attempts), isFalse);
  });

  test('正答率が閾値以上ならマスター済み', () {
    final attempts = [
      ...List.generate(9, (_) => _attempt(true)),
      _attempt(false),
    ];
    expect(eligibility.isMastered(attempts), isTrue);
  });

  test('直近requiredAttempts件のみを見る', () {
    final attempts = [
      ...List.generate(9, (_) => _attempt(true)),
      _attempt(true),
      ...List.generate(20, (_) => _attempt(false)),
    ];
    expect(eligibility.isMastered(attempts), isTrue);
  });
}
