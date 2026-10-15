/// `WeeklyReportBuilder`/`DailyDigestBuilder`が生成したレポートを保護者が
/// 確認済みかどうかを記録する軽量ストア。`reportType`はアプリ側が決める任意の
/// キー（例: `'weekly'`/`'daily'`）とし、本コアはレポートの内容自体には
/// 関与しない。
abstract class ReportReadState {
  /// [reportType]を最後に既読にした時刻。一度も既読にしていない場合は`null`。
  Future<DateTime?> getLastReadAt(String reportType);

  Future<void> markRead(String reportType, DateTime at);

  /// 保護者からのデータ削除要求（LGPD/ECA Digital対応）に応じて全件消去する。
  Future<void> clearAll();
}
