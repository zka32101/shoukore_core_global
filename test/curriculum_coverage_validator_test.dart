import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('CurriculumCoverageValidator', () {
    const validator = CurriculumCoverageValidator();

    test('全小項目が出題済みであれば未カバーなし', () {
      final result = validator.findUncoveredTopics(
        ['t1', 't2', 't3'],
        {'t1', 't2', 't3'},
      );
      expect(result, isEmpty);
    });

    test('一部未出題の小項目があれば一覧に含める', () {
      final result = validator.findUncoveredTopics(
        ['t1', 't2', 't3'],
        {'t1', 't3'},
      );
      expect(result, ['t2']);
    });

    test('小項目が未定義であれば未カバーもなし', () {
      final result = validator.findUncoveredTopics([], {});
      expect(result, isEmpty);
    });
  });
}
