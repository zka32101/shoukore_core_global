/// `GuardianGate`の計算チャレンジへの失敗試行が、通常の子どもの誤入力
/// では考えにくい短い間隔で連続している場合、総当たり的な試行として
/// 警戒すべきかを判定する純関数。`GuardianGateLockout`（連続失敗回数による
/// 一定時間ロック）とは異なり、試行回数ではなく試行間隔の異常さを見る。
/// 実際の警戒時の対応（追加ロック・保護者への通知等）はアプリ側の責務
/// とする。
class GuardianGateRapidAttemptDetector {
  const GuardianGateRapidAttemptDetector({this.minimumPlausibleInterval = const Duration(seconds: 2)});

  /// 人間が計算して入力するのに最低限かかると見なす間隔。
  final Duration minimumPlausibleInterval;

  /// [previousAttemptAt]（直前の失敗試行時刻、初回は`null`）から[now]まで
  /// の間隔が[minimumPlausibleInterval]未満であれば、異常に速い連続試行
  /// として警戒すべきと判定する。
  bool isSuspicious({required DateTime? previousAttemptAt, required DateTime now}) {
    if (previousAttemptAt == null) return false;
    return now.difference(previousAttemptAt) < minimumPlausibleInterval;
  }
}
