/// 同期コンフリクトの解決結果の履歴から、常に同じ側（ローカル優先/
/// サーバー優先）ばかりが採用され続ける偏りがあるかを判定する純関数。
/// `SyncConflictSeverityClassifier`は個々のコンフリクトのデータ損失の
/// 深刻度のみを見るため、解決結果の偏りは見ない。
/// `SyncConflictRecurrenceDetector`は同一データに対するコンフリクトが
/// 繰り返し発生しているかのみを見るため、解決の選択傾向は見ない。
/// 実際の解決ロジックの見直し提案はアプリ側の責務とする。
class SyncConflictResolutionChoiceBiasDetector {
  const SyncConflictResolutionChoiceBiasDetector({this.consecutiveCountThreshold = 5})
      : assert(consecutiveCountThreshold > 0);

  /// 同じ側が連続して採用された回数がこれ以上であれば偏りとみなす。
  final int consecutiveCountThreshold;

  /// [localWasChosenOldestFirst]（各コンフリクトでローカル側が採用された
  /// かどうか、古い順）の末尾が[consecutiveCountThreshold]件以上連続して
  /// 同じ値であれば偏りと判定する。
  bool hasBias(List<bool> localWasChosenOldestFirst) {
    if (localWasChosenOldestFirst.length < consecutiveCountThreshold) return false;

    final tail = localWasChosenOldestFirst.sublist(
      localWasChosenOldestFirst.length - consecutiveCountThreshold,
    );
    final first = tail.first;
    return tail.every((chosen) => chosen == first);
  }
}
