/// `eraseAllUserData`実行後、関連する各ストアが実際に空になったかを
/// 検証する純関数。`eraseAllUserData`自体は削除処理を実行するのみで
/// 削除後の確認は行わないため、本クラスがアプリ側から渡された削除後の
/// 件数一覧を見る。実際の再削除・エラー報告はアプリ側の責務とする。
class DataErasureVerifier {
  const DataErasureVerifier();

  /// [remainingCountsByStore]（ストア名→削除後に残っている件数）の
  /// すべてが0であれば削除完了と判定する。
  bool isFullyErased(Map<String, int> remainingCountsByStore) {
    return remainingCountsByStore.values.every((count) => count == 0);
  }

  /// [remainingCountsByStore]のうち、件数が0でない（削除が不完全な）
  /// ストア名の一覧を返す。
  List<String> incompleteStores(Map<String, int> remainingCountsByStore) {
    return remainingCountsByStore.entries
        .where((entry) => entry.value != 0)
        .map((entry) => entry.key)
        .toList();
  }
}
