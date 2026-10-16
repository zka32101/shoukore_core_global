/// タイムゾーン変更（`TimeZoneDriftDetector`が検知する）が単発の一時的な
/// ブレではなく、継続して観測された場合にのみ、ミッション日境界の再確認を
/// 促すべきかを判定する純関数。`TimeZoneDriftDetector`自体は1回の比較のみを
/// 行うため、起動ごとの揺れ（機内モード中の一時的な誤検知等）で毎回促して
/// しまわないよう、連続観測回数で判断する。実際の再確認ダイアログ表示は
/// アプリ側の責務とする。
class TimeZoneDriftRecalibrationPrompt {
  const TimeZoneDriftRecalibrationPrompt({this.consecutiveDriftsRequired = 2});

  /// この回数以上連続してドリフトが観測されたら再確認を促す。
  final int consecutiveDriftsRequired;

  /// [consecutiveDriftCount]（直近まで連続してドリフトが観測された回数）が
  /// [consecutiveDriftsRequired]以上であれば再確認を促すべきと判定する。
  bool shouldPrompt(int consecutiveDriftCount) {
    return consecutiveDriftCount >= consecutiveDriftsRequired;
  }
}
