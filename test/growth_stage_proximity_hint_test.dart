import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('GrowthStageProximityHint', () {
    const hint = GrowthStageProximityHint();

    test('egg段階ではbabyまでの残りを返す', () {
      expect(hint.remainingToNextStage(4), 6);
    });

    test('baby段階ではchildまでの残りを返す', () {
      expect(hint.remainingToNextStage(20), 30);
    });

    test('child段階ではadultまでの残りを返す', () {
      expect(hint.remainingToNextStage(100), 50);
    });

    test('adult段階ではnullを返す', () {
      expect(hint.remainingToNextStage(150), isNull);
    });
  });
}
