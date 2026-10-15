/// フィードバック音声・効果音（「よくできました」等）の再生要求を抽象化する。
/// `cueId`はアプリ側が音声アセットへ解決するためのキーであり、本コアは
/// 実際の音声アセット・再生エンジン（`audioplayers`等）には依存しない。
abstract class AudioCuePlayer {
  Future<void> play(String cueId);

  /// 再生中の全ての音声を停止する（画面遷移時の後始末等）。
  Future<void> stopAll();
}
