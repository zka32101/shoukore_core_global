import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const suggestion = SiblingProfileSwitchSuggestion(idleThreshold: Duration(minutes: 3));

  test('他のプロフィールがない場合は提案しない', () {
    expect(
      suggestion.shouldSuggestSwitch(
        hasOtherProfiles: false,
        lastInteractionAt: DateTime(2024, 1, 1, 10, 0),
        now: DateTime(2024, 1, 1, 10, 10),
      ),
      isFalse,
    );
  });

  test('無操作時間が閾値未満なら提案しない', () {
    expect(
      suggestion.shouldSuggestSwitch(
        hasOtherProfiles: true,
        lastInteractionAt: DateTime(2024, 1, 1, 10, 0),
        now: DateTime(2024, 1, 1, 10, 1),
      ),
      isFalse,
    );
  });

  test('無操作時間が閾値以上なら提案する', () {
    expect(
      suggestion.shouldSuggestSwitch(
        hasOtherProfiles: true,
        lastInteractionAt: DateTime(2024, 1, 1, 10, 0),
        now: DateTime(2024, 1, 1, 10, 3),
      ),
      isTrue,
    );
  });
}
