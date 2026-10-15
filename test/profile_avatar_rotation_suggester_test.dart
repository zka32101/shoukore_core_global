import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const suggester = ProfileAvatarRotationSuggester();

  test('前回提案がない場合は提案しない', () {
    expect(
      suggester.shouldSuggestRotation(
        previousStage: null,
        currentStage: GrowthStage.baby,
      ),
      isFalse,
    );
  });

  test('進化段階が変わっていなければ提案しない', () {
    expect(
      suggester.shouldSuggestRotation(
        previousStage: GrowthStage.baby,
        currentStage: GrowthStage.baby,
      ),
      isFalse,
    );
  });

  test('進化段階が変わっていれば提案する', () {
    expect(
      suggester.shouldSuggestRotation(
        previousStage: GrowthStage.baby,
        currentStage: GrowthStage.child,
      ),
      isTrue,
    );
  });
}
