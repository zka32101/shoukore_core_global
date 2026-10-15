import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  test('空の履歴に追記できる', () {
    const log = ConsentAuditLog();
    final entry = ConsentAuditEntry(type: 'granted', occurredAt: DateTime(2024, 1, 1));
    final result = log.append([], entry, DateTime(2024, 1, 1));
    expect(result, [entry]);
  });

  test('maxAgeを超えた履歴は削除される', () {
    const log = ConsentAuditLog(maxAge: Duration(days: 30));
    final old = ConsentAuditEntry(type: 'granted', occurredAt: DateTime(2024, 1, 1));
    final newEntry = ConsentAuditEntry(type: 'revoked', occurredAt: DateTime(2024, 3, 1));
    final result = log.append([old], newEntry, DateTime(2024, 3, 1));
    expect(result, [newEntry]);
  });

  test('maxEntriesを超えた分は古いものから削除される', () {
    const log = ConsentAuditLog(maxEntries: 2);
    final e1 = ConsentAuditEntry(type: 'a', occurredAt: DateTime(2024, 1, 1));
    final e2 = ConsentAuditEntry(type: 'b', occurredAt: DateTime(2024, 1, 2));
    final e3 = ConsentAuditEntry(type: 'c', occurredAt: DateTime(2024, 1, 3));
    final result = log.append([e1, e2], e3, DateTime(2024, 1, 3));
    expect(result, [e2, e3]);
  });

  test('policyVersionは任意で保持される', () {
    final entry = ConsentAuditEntry(
      type: 'policy_updated',
      occurredAt: DateTime(2024, 1, 1),
      policyVersion: 2,
    );
    expect(entry.policyVersion, 2);
  });
}
