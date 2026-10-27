import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('ExplanationDepthSelector', () {
    const selector = ExplanationDepthSelector(detailedThreshold: 2);

    test('連続誤答が0であればbrief', () {
      expect(selector.selectDepth(0), ExplanationDepth.brief);
    });

    test('連続誤答が1であればstandard', () {
      expect(selector.selectDepth(1), ExplanationDepth.standard);
    });

    test('連続誤答が閾値以上であればdetailed', () {
      expect(selector.selectDepth(2), ExplanationDepth.detailed);
    });
  });
}
