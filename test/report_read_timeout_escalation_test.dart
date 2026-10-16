import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const escalation = ReportReadTimeoutEscalation(escalateAfter: Duration(days: 3));

  test('未既読（lastReadAtがnull）ならエスカレーションしない', () {
    expect(
      escalation.shouldEscalate(lastReadAt: null, now: DateTime(2024, 1, 1)),
      isFalse,
    );
  });

  test('最終既読から十分日数が経っていなければエスカレーションしない', () {
    expect(
      escalation.shouldEscalate(
        lastReadAt: DateTime(2024, 1, 1),
        now: DateTime(2024, 1, 2),
      ),
      isFalse,
    );
  });

  test('最終既読から十分日数が経っていればエスカレーションする', () {
    expect(
      escalation.shouldEscalate(
        lastReadAt: DateTime(2024, 1, 1),
        now: DateTime(2024, 1, 5),
      ),
      isTrue,
    );
  });
}
