/// `AudioCueVolumeDuckingSuggestion`が算出した推奨ダッキング音量を、
/// ユーザーが頻繁に手動で元の音量に戻している（上書きしている）かを
/// 判定する純関数。`AudioCueVolumeDuckingSuggestion`自体は推奨音量の
/// 算出のみを行い、ユーザーがそれをどう扱ったかは見ない。
/// `AudioMuteStalenessNotice`はミュート状態が続いている期間のみを見る
/// ため、ダッキング推奨への反応は見ない。実際の設定見直し提案の表示は
/// アプリ側の責務とする。
class AudioCueVolumeDuckingOverrideFrequencyDetector {
  const AudioCueVolumeDuckingOverrideFrequencyDetector({this.overrideCountThreshold = 5})
      : assert(overrideCountThreshold > 0);

  /// 直近の件数のうちこの回数以上上書きされていれば頻発とみなす。
  final int overrideCountThreshold;

  /// [recentOverrideFlags]（直近のダッキング推奨ごとに、ユーザーが手動で
  /// 元の音量に戻したかどうかのリスト）のうち上書きされた件数が
  /// [overrideCountThreshold]以上であれば頻発と判定する。
  bool isFrequentlyOverridden(List<bool> recentOverrideFlags) {
    final overrideCount = recentOverrideFlags.where((overridden) => overridden).length;
    return overrideCount >= overrideCountThreshold;
  }
}
