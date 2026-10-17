import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const verifier = DataErasureVerifier();

  test('すべてのストアが0件なら削除完了と判定する', () {
    expect(verifier.isFullyErased({'consent': 0, 'progress': 0}), isTrue);
  });

  test('1件でも残っていれば削除完了と判定しない', () {
    expect(verifier.isFullyErased({'consent': 0, 'progress': 2}), isFalse);
  });

  test('incompleteStoresは残件数が0でないストア名のみ返す', () {
    expect(
      verifier.incompleteStores({'consent': 0, 'progress': 2, 'inventory': 1}),
      equals(['progress', 'inventory']),
    );
  });
}
