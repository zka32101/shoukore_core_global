/// `parseRegionalProfile`による地域プロファイルの読み込みが連続して
/// 失敗し、既定値へのフォールバックが続いている状態を知らせるべきかを
/// 判定する純関数。`RegionalProfileChangeDetector`は正常に読み込めた
/// プロファイル同士の内容変化のみを見るため、読み込み失敗自体は見ない。
/// `LocaleCurriculumStalenessNotice`はカリキュラムデータの古さのみを
/// 見るため、プロファイルの読み込み失敗は見ない。実際のフォールバック
/// 通知の表示・再試行はアプリ側の責務とする。
class RegionalProfileLoadFailureFallbackNotice {
  const RegionalProfileLoadFailureFallbackNotice({this.consecutiveFailureThreshold = 2})
      : assert(consecutiveFailureThreshold > 0);

  /// 連続してこの回数以上読み込みに失敗したら通知対象とみなす。
  final int consecutiveFailureThreshold;

  /// [consecutiveLoadFailureCount]（直近から連続して読み込みに失敗した
  /// 回数）が[consecutiveFailureThreshold]以上であれば、フォールバックの
  /// 通知が必要と判定する。
  bool shouldNotify(int consecutiveLoadFailureCount) {
    return consecutiveLoadFailureCount >= consecutiveFailureThreshold;
  }
}
