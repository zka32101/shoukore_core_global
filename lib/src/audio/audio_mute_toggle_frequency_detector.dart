/// 効果音/BGMのミュート/解除の切り替えが短時間に頻発している状態を検知
/// する純関数。`AudioMuteStalenessNotice`はミュートし続けている期間の
/// 長さのみを見るため、頻繁な切り替え自体は見ない。実際の設定UIの見直し
/// 案内はアプリ側の責務とする。
class AudioMuteToggleFrequencyDetector {
  const AudioMuteToggleFrequencyDetector({
    this.toggleCountThreshold = 4,
    this.observationWindow = const Duration(minutes: 10),
  }) : assert(toggleCountThreshold > 0);

  /// この時間内の切り替え件数がこの回数以上であれば頻発とみなす。
  final int toggleCountThreshold;

  /// 切り替え件数を数える観測期間。
  final Duration observationWindow;

  /// [toggledAtTimestamps]（ミュート/解除が切り替わった時刻の一覧）のうち、
  /// [now]から[observationWindow]以内に含まれる件数が[toggleCountThreshold]
  /// 以上であれば、頻発状態と判定する。
  bool isTogglingFrequently({
    required List<DateTime> toggledAtTimestamps,
    required DateTime now,
  }) {
    final recentCount = toggledAtTimestamps.where((toggledAt) {
      return now.difference(toggledAt) <= observationWindow;
    }).length;
    return recentCount >= toggleCountThreshold;
  }
}
