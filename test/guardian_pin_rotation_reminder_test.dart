import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const reminder = GuardianPinRotationReminder(rotationInterval: Duration(days: 180));

  test('変更記録がない場合は常に促す', () {
    expect(
      reminder.shouldRemind(lastChangedAt: null, now: DateTime(2024, 1, 1)),
      isTrue,
    );
  });

  test('ローテーション期間内なら促さない', () {
    expect(
      reminder.shouldRemind(
        lastChangedAt: DateTime(2024, 1, 1),
        now: DateTime(2024, 3, 1),
      ),
      isFalse,
    );
  });

  test('ローテーション期間を超えたら促す', () {
    expect(
      reminder.shouldRemind(
        lastChangedAt: DateTime(2024, 1, 1),
        now: DateTime(2024, 8, 1),
      ),
      isTrue,
    );
  });
}
