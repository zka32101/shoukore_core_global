/// 同一フィールド（レコード識別子）で同期コンフリクトが繰り返し発生して
/// いる再発状態を検知する純関数。`SyncConflictSeverityClassifier`は
/// 単発のコンフリクトについて採用されなかった側のデータが失われる程度
/// （深刻度）のみを判定するため、同じ対象で再発しているかどうかは見ない。
/// 実際の再発箇所の個別調査・警告表示はアプリ側の責務とする。
class SyncConflictRecurrenceDetector {
  const SyncConflictRecurrenceDetector({this.recurrenceThreshold = 3});

  /// 同一対象でこの回数以上コンフリクトが発生したら再発とみなす。
  final int recurrenceThreshold;

  /// [conflictCountByRecordId]（直近の集計期間における、レコード識別子
  /// ごとのコンフリクト発生回数）のうち、[recurrenceThreshold]以上の
  /// 発生回数を持つレコード識別子の集合を返す。
  Set<String> findRecurringRecordIds(Map<String, int> conflictCountByRecordId) {
    return conflictCountByRecordId.entries
        .where((entry) => entry.value >= recurrenceThreshold)
        .map((entry) => entry.key)
        .toSet();
  }
}
