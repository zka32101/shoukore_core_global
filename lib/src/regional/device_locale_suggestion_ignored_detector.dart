/// `DeviceLocaleSuggester`が提案したロケールと異なるロケールをユーザーが
/// 連続して選び続けている状態を検知する純関数。`DeviceLocaleSuggester`
/// 自体は端末ロケールに最も近い対応済みロケールを算出するのみで、提案後
/// にユーザーがどう選んだかは見ない。実際の提案方法の見直し・表示頻度の
/// 調整はアプリ側の責務とする。
class DeviceLocaleSuggestionIgnoredDetector {
  const DeviceLocaleSuggestionIgnoredDetector({this.ignoredThreshold = 3})
      : assert(ignoredThreshold > 0);

  /// 連続無視がこの回数以上になったら検知対象とみなす。
  final int ignoredThreshold;

  /// [consecutiveIgnoredCount]（直近から連続して、提案と異なるロケールが
  /// 選ばれた回数）が[ignoredThreshold]以上であれば、連続無視状態と
  /// 判定する。
  bool isPersistentlyIgnored(int consecutiveIgnoredCount) {
    return consecutiveIgnoredCount >= ignoredThreshold;
  }
}
