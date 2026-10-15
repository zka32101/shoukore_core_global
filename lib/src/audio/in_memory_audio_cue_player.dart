import 'audio_cue_player.dart';

/// テスト・プロトタイプ用の`AudioCuePlayer`実装。実運用では`audioplayers`等の
/// 実機音声アダプタに置き換える。再生履歴を記録するだけで、実際の音声は
/// 再生しない。
class InMemoryAudioCuePlayer implements AudioCuePlayer {
  final List<String> _playedCueIds = [];
  int _stopAllCallCount = 0;

  /// `play()`が呼ばれた`cueId`の履歴（`stopAll()`では消えない）。
  List<String> get playedCueIds => List.unmodifiable(_playedCueIds);

  /// `stopAll()`が呼ばれた回数（結合テストでの検証用）。
  int get stopAllCallCount => _stopAllCallCount;

  @override
  Future<void> play(String cueId) async {
    _playedCueIds.add(cueId);
  }

  @override
  Future<void> stopAll() async {
    _stopAllCallCount++;
  }
}
