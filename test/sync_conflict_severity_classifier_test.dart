import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const classifier = SyncConflictSeverityClassifier();

  test('採用されなかった側の内容が同じなら軽微と判定する', () {
    final local = SyncableRecord(payload: const {'score': 10}, updatedAt: DateTime(2024, 1, 2));
    final remote = SyncableRecord(payload: const {'score': 10}, updatedAt: DateTime(2024, 1, 1));
    final severity = classifier.classify(local: local, remote: remote, resolved: local);
    expect(severity, SyncConflictSeverity.minor);
  });

  test('採用されなかった側の内容が異なれば重大と判定する', () {
    final local = SyncableRecord(payload: const {'score': 20}, updatedAt: DateTime(2024, 1, 2));
    final remote = SyncableRecord(payload: const {'score': 10}, updatedAt: DateTime(2024, 1, 1));
    final severity = classifier.classify(local: local, remote: remote, resolved: local);
    expect(severity, SyncConflictSeverity.major);
  });
}
