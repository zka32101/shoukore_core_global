import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('WeakNoteBacklogGrowthRateAlert', () {
    const alert = WeakNoteBacklogGrowthRateAlert(growthCountThreshold: 3);

    test('増加分が閾値以上なら急増と判定', () {
      expect(
        alert.isGrowingRapidly(previousUnresolvedCount: 2, currentUnresolvedCount: 5),
        isTrue,
      );
    });

    test('増加分が閾値未満なら急増ではない', () {
      expect(
        alert.isGrowingRapidly(previousUnresolvedCount: 2, currentUnresolvedCount: 4),
        isFalse,
      );
    });

    test('件数が減っていれば急増ではない', () {
      expect(
        alert.isGrowingRapidly(previousUnresolvedCount: 5, currentUnresolvedCount: 2),
        isFalse,
      );
    });
  });
}
