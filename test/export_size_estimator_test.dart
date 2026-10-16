import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const estimator = ExportSizeEstimator(maxBytes: 100);

  test('バイト数が閾値以内なら分割不要', () {
    final items = [
      {'a': 1},
    ];
    expect(estimator.needsChunking(items), isFalse);
  });

  test('バイト数が閾値を超えれば分割が必要', () {
    final items = List.generate(50, (i) => {'id': 'item_$i', 'value': 'x' * 10});
    expect(estimator.needsChunking(items), isTrue);
  });

  test('estimateBytesは実際のJSON文字列のバイト数と一致する', () {
    final items = [
      {'a': 1},
    ];
    expect(estimator.estimateBytes(items), equals('[{"a":1}]'.length));
  });
}
