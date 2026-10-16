/// アプリが前回終了した時刻から今回起動までの間隔が長時間（オフライン
/// ギャップ）であったかを判定する純関数。`StaleDataPolicy`（サーバーとの
/// 最終同期からの経過による要同期判定）とは異なり、ローカルな
/// 起動間隔のみを見て、復帰時の演出・案内を出す判断材料とする。実際の
/// 復帰時UI・再同期のトリガーはアプリ側の責務とする。
class OfflineSessionGapDetector {
  const OfflineSessionGapDetector({this.gapThreshold = const Duration(days: 3)});

  /// この期間以上間隔が空いていれば長時間オフラインとみなす。
  final Duration gapThreshold;

  /// [lastSessionEndedAt]が`null`（初回起動）の場合は`false`を返す。
  /// それ以外は、[now]との差が[gapThreshold]以上であれば`true`を返す。
  bool isLongGap({required DateTime? lastSessionEndedAt, required DateTime now}) {
    if (lastSessionEndedAt == null) return false;
    return now.difference(lastSessionEndedAt) >= gapThreshold;
  }
}
