import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const preference = MissionCompletionTimePreference(minimumSampleSize: 5);

  test('件数が最小サンプル数未満ならnullを返す', () {
    expect(
      preference.mostFrequentHour([
        DateTime(2024, 1, 1, 18),
        DateTime(2024, 1, 2, 18),
      ]),
      isNull,
    );
  });

  test('最も件数が多い時間を返す', () {
    expect(
      preference.mostFrequentHour([
        DateTime(2024, 1, 1, 18),
        DateTime(2024, 1, 2, 18),
        DateTime(2024, 1, 3, 18),
        DateTime(2024, 1, 4, 8),
        DateTime(2024, 1, 5, 18),
      ]),
      equals(18),
    );
  });

  test('同数の場合は最も早い時間を返す', () {
    expect(
      preference.mostFrequentHour([
        DateTime(2024, 1, 1, 20),
        DateTime(2024, 1, 2, 20),
        DateTime(2024, 1, 3, 8),
        DateTime(2024, 1, 4, 8),
        DateTime(2024, 1, 5, 12),
      ]),
      equals(8),
    );
  });
}
