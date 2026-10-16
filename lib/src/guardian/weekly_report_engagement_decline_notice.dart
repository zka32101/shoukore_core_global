/// 直近複数回分の週次レポートの既読率が継続して低い場合に、通知方法
/// 自体の見直しを提案すべきかを判定する純関数。`ReportReadTimeoutEscalation`
/// （直近1件のレポートの未読が長期化した場合のエスカレーション）とは
/// 異なり、本クラスは複数回のレポートにわたる既読傾向のみを見る。
/// 実際の通知方法の変更案提示はアプリ側の責務とする。
class WeeklyReportEngagementDeclineNotice {
  const WeeklyReportEngagementDeclineNotice({
    this.minimumSampleSize = 4,
    this.readRateThreshold = 0.25,
  });

  /// 判定に必要な最小レポート件数。これ未満なら判定しない。
  final int minimumSampleSize;

  /// 既読率がこれ以下であれば通知方法の見直しを提案すべきと判定する。
  final double readRateThreshold;

  /// [wasReadNewestFirst]（直近のレポートから新しい順の既読フラグ列）
  /// のうち、既読だった割合が[readRateThreshold]以下であれば見直しを
  /// 提案すべきと判定する。件数が[minimumSampleSize]未満の場合は判定
  /// しない。
  bool shouldSuggestReview(List<bool> wasReadNewestFirst) {
    if (wasReadNewestFirst.length < minimumSampleSize) return false;

    final readCount = wasReadNewestFirst.where((wasRead) => wasRead).length;
    return readCount / wasReadNewestFirst.length <= readRateThreshold;
  }
}
