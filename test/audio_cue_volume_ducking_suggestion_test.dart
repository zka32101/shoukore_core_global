import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const suggestion = AudioCueVolumeDuckingSuggestion(duckedVolumeRatio: 0.3);

  test('BGM再生中に効果音も再生中ならダッキングすべき', () {
    expect(suggestion.shouldDuck(bgmIsPlaying: true, cuePlaying: true), isTrue);
  });

  test('BGMが再生中でなければダッキング不要', () {
    expect(suggestion.shouldDuck(bgmIsPlaying: false, cuePlaying: true), isFalse);
  });

  test('効果音が再生中でなければダッキング不要', () {
    expect(suggestion.shouldDuck(bgmIsPlaying: true, cuePlaying: false), isFalse);
  });

  test('推奨ダッキング音量は通常音量×比率になる', () {
    expect(suggestion.duckedVolumeFor(1.0), closeTo(0.3, 0.0001));
    expect(suggestion.duckedVolumeFor(0.5), closeTo(0.15, 0.0001));
  });
}
