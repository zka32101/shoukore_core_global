import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('AudioMuteStalenessNotice', () {
    const notice = AudioMuteStalenessNotice();
    final now = DateTime(2026, 3, 1);

    test('ミュートしていない場合は提案しない', () {
      expect(
        notice.shouldSuggestUnmuteConfirmation(
          isMuted: false,
          mutedSince: now.subtract(const Duration(days: 30)),
          now: now,
        ),
        isFalse,
      );
    });

    test('ミュートがstalenessPeriodを超えて続いていれば提案すべきと判定する', () {
      expect(
        notice.shouldSuggestUnmuteConfirmation(
          isMuted: true,
          mutedSince: now.subtract(const Duration(days: 15)),
          now: now,
        ),
        isTrue,
      );
    });

    test('ミュートがstalenessPeriod以内であれば提案しない', () {
      expect(
        notice.shouldSuggestUnmuteConfirmation(
          isMuted: true,
          mutedSince: now.subtract(const Duration(days: 5)),
          now: now,
        ),
        isFalse,
      );
    });
  });
}
