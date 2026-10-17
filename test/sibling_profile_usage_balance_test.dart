import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const balance = SiblingProfileUsageBalance(dominantShareThreshold: 0.8);

  test('プロフィールが1件のみなら偏りと判定しない', () {
    expect(
      balance.isImbalanced({'a': const Duration(hours: 10)}),
      isFalse,
    );
  });

  test('利用時間がほぼ均等なら偏りと判定しない', () {
    expect(
      balance.isImbalanced({
        'a': const Duration(hours: 5),
        'b': const Duration(hours: 5),
      }),
      isFalse,
    );
  });

  test('1人が8割以上を占めれば偏りと判定する', () {
    expect(
      balance.isImbalanced({
        'a': const Duration(hours: 9),
        'b': const Duration(hours: 1),
      }),
      isTrue,
    );
  });
}
