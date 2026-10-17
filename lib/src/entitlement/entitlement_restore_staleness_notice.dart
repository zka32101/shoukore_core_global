/// 購入復元（リストア）が長期間実行されていないことに気づけるようにする
/// 純関数。`EntitlementRestorePrompt`（現在の権利情報が以前の記録と
/// 食い違っている場合に復元を促す判定）とは異なり、本クラスは権利情報の
/// 食い違いの有無を見ず、最後に復元を実行した時刻からの経過時間のみを見る。
/// 別デバイスでの購入状態の不整合リスクに、食い違いが表面化する前に
/// 気づく手がかりとする。実際の復元操作の案内はアプリ側の責務とする。
class EntitlementRestoreStalenessNotice {
  const EntitlementRestoreStalenessNotice({this.stalenessPeriod = const Duration(days: 30)});

  /// 最後の復元実行からこの期間を超えていれば、復元を提案すべきと判定する。
  final Duration stalenessPeriod;

  /// [lastRestoredAt]（最後に復元を実行した時刻、未実行は`null`）から
  /// [now]までの経過時間が[stalenessPeriod]を超えていれば、復元を提案
  /// すべきと判定する。[lastRestoredAt]が`null`の場合は一度も復元して
  /// いないとみなし、常に提案すべきと判定する。
  bool shouldSuggestRestore({required DateTime? lastRestoredAt, required DateTime now}) {
    if (lastRestoredAt == null) return true;
    return now.difference(lastRestoredAt) > stalenessPeriod;
  }
}
