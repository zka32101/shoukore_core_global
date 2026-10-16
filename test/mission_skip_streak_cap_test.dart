import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const cap = MissionSkipStreakCap(maxConsecutiveSkips: 7);

  test('連続スキップ日数が上限未満なら対象外にしない', () {
    expect(cap.exceedsCap(3), isFalse);
  });

  test('連続スキップ日数が上限に達したら対象外にする', () {
    expect(cap.exceedsCap(7), isTrue);
  });

  test('連続スキップ日数が上限を超えたら対象外にする', () {
    expect(cap.exceedsCap(10), isTrue);
  });
}
