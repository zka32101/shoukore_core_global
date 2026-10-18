import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('ProfileSwitchRevertDetector', () {
    const detector = ProfileSwitchRevertDetector(revertWindow: Duration(seconds: 10));
    final switchedAt = DateTime(2026, 10, 18, 12, 0, 0);

    test('短時間で元のプロフィールに戻れば誤操作と判定', () {
      expect(
        detector.isAccidentalSwitch(
          previousProfileId: 'profile-a',
          revertedToProfileId: 'profile-a',
          switchedAt: switchedAt,
          revertedAt: switchedAt.add(const Duration(seconds: 5)),
        ),
        isTrue,
      );
    });

    test('時間が空いていれば誤操作ではない', () {
      expect(
        detector.isAccidentalSwitch(
          previousProfileId: 'profile-a',
          revertedToProfileId: 'profile-a',
          switchedAt: switchedAt,
          revertedAt: switchedAt.add(const Duration(minutes: 5)),
        ),
        isFalse,
      );
    });

    test('異なるプロフィールへの切替なら誤操作ではない', () {
      expect(
        detector.isAccidentalSwitch(
          previousProfileId: 'profile-a',
          revertedToProfileId: 'profile-b',
          switchedAt: switchedAt,
          revertedAt: switchedAt.add(const Duration(seconds: 2)),
        ),
        isFalse,
      );
    });
  });
}
