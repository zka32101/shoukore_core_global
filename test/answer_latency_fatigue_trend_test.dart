import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const trend = AnswerLatencyFatigueTrend(
    minimumSampleSize: 6,
    slowdownRatioThreshold: 1.5,
  );

  test('件数が最小サンプル数未満なら判定しない', () {
    expect(
      trend.isSlowingDown(const [
        Duration(seconds: 2),
        Duration(seconds: 2),
        Duration(seconds: 2),
      ]),
      isFalse,
    );
  });

  test('解答時間が安定していれば低下傾向なし', () {
    expect(
      trend.isSlowingDown(const [
        Duration(seconds: 2),
        Duration(seconds: 2),
        Duration(seconds: 2),
        Duration(seconds: 2),
        Duration(seconds: 2),
        Duration(seconds: 2),
      ]),
      isFalse,
    );
  });

  test('後半が前半の1.5倍以上遅ければ低下傾向あり', () {
    expect(
      trend.isSlowingDown(const [
        Duration(seconds: 2),
        Duration(seconds: 2),
        Duration(seconds: 2),
        Duration(seconds: 4),
        Duration(seconds: 4),
        Duration(seconds: 4),
      ]),
      isTrue,
    );
  });
}
