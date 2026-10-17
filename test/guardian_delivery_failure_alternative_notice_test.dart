import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('GuardianDeliveryFailureAlternativeNotice', () {
    const notice = GuardianDeliveryFailureAlternativeNotice();

    test('連続failureThreshold回以上配信失敗していれば提案すべきと判定する', () {
      expect(notice.shouldSuggestAlternativeChannel([false, false, false, true]), isTrue);
    });

    test('連続失敗回数がthreshold未満なら提案しない', () {
      expect(notice.shouldSuggestAlternativeChannel([false, false, true, false]), isFalse);
    });

    test('直近が配信成功していれば提案しない', () {
      expect(notice.shouldSuggestAlternativeChannel([true, false, false, false]), isFalse);
    });

    test('空リストでは提案しない', () {
      expect(notice.shouldSuggestAlternativeChannel([]), isFalse);
    });
  });
}
