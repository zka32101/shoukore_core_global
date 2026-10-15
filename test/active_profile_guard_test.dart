import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const guard = ActiveProfileGuard();

  group('ActiveProfileGuard', () {
    test('isSameProfileは一致していればtrue', () {
      expect(
        guard.isSameProfile(expectedProfileId: 'p1', currentActiveProfileId: 'p1'),
        isTrue,
      );
    });

    test('isSameProfileは一致していなければfalse', () {
      expect(
        guard.isSameProfile(expectedProfileId: 'p1', currentActiveProfileId: 'p2'),
        isFalse,
      );
    });

    test('両方nullなら一致とみなす（未作成プロファイルの状態）', () {
      expect(
        guard.isSameProfile(expectedProfileId: null, currentActiveProfileId: null),
        isTrue,
      );
    });

    test('ensureSameProfileは一致していれば例外を投げない', () {
      expect(
        () => guard.ensureSameProfile(expectedProfileId: 'p1', currentActiveProfileId: 'p1'),
        returnsNormally,
      );
    });

    test('ensureSameProfileは一致していなければStateErrorを投げる', () {
      expect(
        () => guard.ensureSameProfile(expectedProfileId: 'p1', currentActiveProfileId: 'p2'),
        throwsStateError,
      );
    });
  });
}
