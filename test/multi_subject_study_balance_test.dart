import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('MultiSubjectStudyBalance', () {
    const balance = MultiSubjectStudyBalance(imbalanceRatioThreshold: 3.0);

    test('比率が閾値以上なら偏りあり', () {
      expect(balance.isImbalanced({'math': 30, 'japanese': 10}), isTrue);
    });

    test('比率が閾値未満なら偏りなし', () {
      expect(balance.isImbalanced({'math': 15, 'japanese': 10}), isFalse);
    });

    test('一方が0件で他方に回答があれば偏りあり', () {
      expect(balance.isImbalanced({'math': 5, 'japanese': 0}), isTrue);
    });

    test('教科が1件のみなら偏りなし', () {
      expect(balance.isImbalanced({'math': 30}), isFalse);
    });

    test('最も回答数が少ない教科を返す', () {
      expect(
        balance.mostNeglectedSubject({'math': 30, 'japanese': 10, 'science': 5}),
        'science',
      );
    });
  });
}
