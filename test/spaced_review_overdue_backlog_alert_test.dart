import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('SpacedReviewOverdueBacklogAlert', () {
    const alert = SpacedReviewOverdueBacklogAlert(backlogThreshold: 3);

    test('復習期限到来件数が閾値以上なら積み上がりと判定', () {
      expect(alert.isBacklogged(['a', 'b', 'c']), isTrue);
    });

    test('復習期限到来件数が閾値未満なら積み上がりではない', () {
      expect(alert.isBacklogged(['a', 'b']), isFalse);
    });

    test('空リストなら積み上がりではない', () {
      expect(alert.isBacklogged(const []), isFalse);
    });
  });
}
