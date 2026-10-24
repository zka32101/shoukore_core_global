/// `AudioCueRepetitionFatigueDetector`が検知した同一音声キューの繰り返し
/// 再生による疲労状態が解消し、連続して多様な再生と判定され続けている
/// かを判定する純関数。`AudioCueRepetitionFatigueDetector`自体は1回の
/// 直近履歴ウィンドウのみを見る単発判定であり、解消の確認自体は見ない。
/// 実際の音声バリエーション切り替え・再生間引きの解除方法の見直しは
/// アプリ側の責務とする。
class AudioCueRepetitionFatigueRecoveryDetector {
  const AudioCueRepetitionFatigueRecoveryDetector({
    this.recoveryThreshold = 3,
  }) : assert(recoveryThreshold > 0);

  final int recoveryThreshold;

  bool isRecovered(int consecutiveNonFatiguedCount) {
    return consecutiveNonFatiguedCount >= recoveryThreshold;
  }
}
