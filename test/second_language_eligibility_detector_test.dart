import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('SecondLanguageEligibilityDetector', () {
    const detector = SecondLanguageEligibilityDetector(
      primaryLanguageCode: 'en',
    );

    test('主言語が英語以外であれば第二言語として英語を選択可能', () {
      expect(detector.isEligible('ja'), isTrue);
    });

    test('主言語がポルトガル語でも第二言語として英語を選択可能', () {
      expect(detector.isEligible('pt'), isTrue);
    });

    test('主言語が既に英語であれば対象外', () {
      expect(detector.isEligible('en'), isFalse);
    });
  });
}
