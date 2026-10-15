import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('InMemoryAudioCuePlayer', () {
    test('playでcueIdの再生履歴が記録される', () async {
      final player = InMemoryAudioCuePlayer();
      await player.play('correct_answer');
      await player.play('mission_complete');

      expect(player.playedCueIds, ['correct_answer', 'mission_complete']);
    });

    test('stopAllを呼んでも再生履歴は消えない', () async {
      final player = InMemoryAudioCuePlayer();
      await player.play('correct_answer');
      await player.stopAll();

      expect(player.playedCueIds, ['correct_answer']);
      expect(player.stopAllCallCount, 1);
    });
  });
}
