/// 直近の音声キュー再生に同じ`cueId`が繰り返し再生されすぎている疲労状態を
/// 検知する純関数。`QuestionRepetitionFatigueDetector`は出題問題ID単位の
/// 繰り返しのみを見るため、音声キューの再生自体が繰り返されているかは
/// 見ない。`AudioMuteStalenessNotice`はミュート放置期間のみを見るため、
/// 再生頻度の偏りは見ない。実際の音声バリエーション切り替え・再生間引きは
/// アプリ側の責務とする。
class AudioCueRepetitionFatigueDetector {
  const AudioCueRepetitionFatigueDetector({this.repetitionThreshold = 3});

  /// 直近の再生件数のうち、同一`cueId`がこの件数以上含まれていれば疲労
  /// とみなす。
  final int repetitionThreshold;

  /// [recentCueIds]（直近に再生された音声キューID列）のうち、最も頻出する
  /// `cueId`の出現回数が[repetitionThreshold]以上であれば、疲労状態と判定する。
  bool isFatigued(List<String> recentCueIds) {
    if (recentCueIds.isEmpty) return false;
    final counts = <String, int>{};
    for (final id in recentCueIds) {
      counts[id] = (counts[id] ?? 0) + 1;
    }
    final maxCount = counts.values.reduce((a, b) => a > b ? a : b);
    return maxCount >= repetitionThreshold;
  }
}
