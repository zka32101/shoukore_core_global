import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const reminder = ConsentRenewalReminder(
    validity: Duration(days: 365),
    leadTime: Duration(days: 14),
  );

  test('同意が得られていなければリマインドしない', () {
    const record = ConsentRecord(parentalConsentGiven: false);
    expect(reminder.shouldRemind(record, DateTime(2024, 1, 1)), isFalse);
  });

  test('期限まで十分余裕があればリマインドしない', () {
    final record = ConsentRecord(parentalConsentGiven: true, consentedAt: DateTime(2024, 1, 1));
    expect(reminder.shouldRemind(record, DateTime(2024, 6, 1)), isFalse);
  });

  test('期限切れ直前（リードタイム以内）ならリマインドする', () {
    final record = ConsentRecord(parentalConsentGiven: true, consentedAt: DateTime(2024, 1, 1));
    expect(reminder.shouldRemind(record, DateTime(2024, 12, 25)), isTrue);
  });

  test('既に期限切れならリマインドしない', () {
    final record = ConsentRecord(parentalConsentGiven: true, consentedAt: DateTime(2024, 1, 1));
    expect(reminder.shouldRemind(record, DateTime(2025, 2, 1)), isFalse);
  });
}
