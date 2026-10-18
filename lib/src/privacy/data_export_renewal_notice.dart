/// 以前に書き出した`exportUserData`の結果が長期間再生成されていない場合、
/// 保護者に最新の書き出しを促すべきかを判定する純関数。
/// `DataExportRequestThrottle`（連続要求の抑制、短すぎる間隔を防ぐ）とは
/// 異なり、本クラスは最後に書き出した時刻からの経過時間が長すぎる場合の
/// みを見る。実際の書き出し再実行の案内はアプリ側の責務とする。
class DataExportRenewalNotice {
  const DataExportRenewalNotice({this.stalenessPeriod = const Duration(days: 180)});

  /// 最後の書き出しからこの期間を超えていれば、再発行を提案すべきと判定する。
  final Duration stalenessPeriod;

  /// [lastExportedAt]（最後に書き出しを実行した時刻、未実行は`null`）から
  /// [now]までの経過時間が[stalenessPeriod]を超えていれば、再発行を提案
  /// すべきと判定する。[lastExportedAt]が`null`の場合は一度も書き出して
  /// いないとみなし、提案しない（まだ要求されていないため）。
  bool shouldSuggestRenewal({required DateTime? lastExportedAt, required DateTime now}) {
    if (lastExportedAt == null) return false;
    return now.difference(lastExportedAt) > stalenessPeriod;
  }
}
