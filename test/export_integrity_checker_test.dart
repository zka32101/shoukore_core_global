import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const checker = ExportIntegrityChecker();

  test('正しい構造ならエラーなし', () {
    final data = {
      'consent': {
        'parentalConsentGiven': true,
        'consentedAt': '2024-01-01T00:00:00.000',
        'policyVersion': 1,
      },
      'progress': [
        {'unitId': 'a', 'score': 0.5, 'lastPracticedAt': '2024-01-01T00:00:00.000'},
      ],
    };
    expect(checker.validate(data), isEmpty);
    expect(checker.isValid(data), isTrue);
  });

  test('consentがnullでもエラーなし', () {
    final data = {'consent': null, 'progress': <Map<String, dynamic>>[]};
    expect(checker.validate(data), isEmpty);
  });

  test('consentキーがなければエラー', () {
    final data = {'progress': <Map<String, dynamic>>[]};
    expect(checker.validate(data), contains('"consent"キーが存在しません'));
  });

  test('progressキーがなければエラー', () {
    final data = {'consent': null};
    expect(checker.validate(data), contains('"progress"キーが存在しません'));
  });

  test('progressがListでなければエラー', () {
    final data = {'consent': null, 'progress': 'not a list'};
    expect(checker.validate(data), contains('"progress"はList型である必要があります'));
  });

  test('parentalConsentGivenの型が不正ならエラー', () {
    final data = {
      'consent': {'parentalConsentGiven': 'yes', 'policyVersion': 1},
      'progress': <Map<String, dynamic>>[],
    };
    expect(
      checker.validate(data),
      contains('"consent.parentalConsentGiven"はbool型である必要があります'),
    );
  });

  test('progress要素のunitIdの型が不正ならエラー', () {
    final data = {
      'consent': null,
      'progress': [
        {'unitId': 123, 'score': 0.5},
      ],
    };
    expect(checker.validate(data), contains('"progress[0].unitId"はString型である必要があります'));
    expect(checker.isValid(data), isFalse);
  });
}
