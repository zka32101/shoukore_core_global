import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('LocaleCurriculumStalenessNotice', () {
    const notice = LocaleCurriculumStalenessNotice();

    test('現在のロケールと最後に読み込んだロケールが異なれば未読み込みと判定する', () {
      expect(
        notice.isCurriculumStale(
          currentLocale: 'pt_BR',
          lastLoadedCurriculumLocale: 'ja',
        ),
        isTrue,
      );
    });

    test('現在のロケールと最後に読み込んだロケールが一致すれば未読み込みと判定しない', () {
      expect(
        notice.isCurriculumStale(
          currentLocale: 'ja',
          lastLoadedCurriculumLocale: 'ja',
        ),
        isFalse,
      );
    });

    test('一度も読み込んでいない場合は未読み込みと判定する', () {
      expect(
        notice.isCurriculumStale(
          currentLocale: 'ja',
          lastLoadedCurriculumLocale: null,
        ),
        isTrue,
      );
    });
  });
}
