import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('SeasonalEventValidityGuard', () {
    const guard = SeasonalEventValidityGuard();
    final startAt = DateTime(2026, 2, 1);
    final endAt = DateTime(2026, 2, 14, 23, 59, 59);

    test('開始〜終了の範囲内であればイベント期間内と判定する', () {
      expect(
        guard.isWithinEventPeriod(startAt: startAt, endAt: endAt, now: DateTime(2026, 2, 10)),
        isTrue,
      );
    });

    test('終了より後であればイベント期間外と判定する', () {
      expect(
        guard.isWithinEventPeriod(startAt: startAt, endAt: endAt, now: DateTime(2026, 2, 15)),
        isFalse,
      );
    });

    test('タイムゾーンがズレていて終了時刻の近傍であれば再確認を提案する', () {
      expect(
        guard.shouldRevalidateWithServerTime(
          hasTimeZoneDrifted: true,
          endAt: endAt,
          now: endAt.add(const Duration(minutes: 30)),
        ),
        isTrue,
      );
    });

    test('タイムゾーンがズレていなければ再確認を提案しない', () {
      expect(
        guard.shouldRevalidateWithServerTime(
          hasTimeZoneDrifted: false,
          endAt: endAt,
          now: endAt.add(const Duration(minutes: 30)),
        ),
        isFalse,
      );
    });

    test('終了時刻からgracePeriod以上離れていれば再確認を提案しない', () {
      expect(
        guard.shouldRevalidateWithServerTime(
          hasTimeZoneDrifted: true,
          endAt: endAt,
          now: endAt.add(const Duration(hours: 3)),
        ),
        isFalse,
      );
    });
  });
}
