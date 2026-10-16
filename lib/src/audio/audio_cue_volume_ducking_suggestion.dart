/// BGM等が再生中に効果音（`AudioCuePlayer`）を鳴らす際、BGM音量を一時的に
/// 下げる（ダッキング）べきかと、その際の推奨音量を算出する純関数。
/// `AudioCuePlayer`自体は再生のみを担い、音量ミキシングの方針には関与
/// しないため、本クラスは単純な比率計算のみを行う。実際の音量制御・
/// フェード処理はアプリ側の責務とする。
class AudioCueVolumeDuckingSuggestion {
  const AudioCueVolumeDuckingSuggestion({this.duckedVolumeRatio = 0.3})
      : assert(duckedVolumeRatio >= 0 && duckedVolumeRatio <= 1);

  /// 効果音再生中のBGM音量を、通常音量に対してこの比率まで下げることを
  /// 推奨する。
  final double duckedVolumeRatio;

  /// [bgmIsPlaying]かつ[cuePlaying]であればダッキングすべきと判定する。
  bool shouldDuck({required bool bgmIsPlaying, required bool cuePlaying}) {
    return bgmIsPlaying && cuePlaying;
  }

  /// [normalVolume]（通常のBGM音量、0.0〜1.0）に対して、ダッキング時に
  /// 推奨される音量を返す。
  double duckedVolumeFor(double normalVolume) {
    return normalVolume * duckedVolumeRatio;
  }
}
