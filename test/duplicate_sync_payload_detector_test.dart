import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const detector = DuplicateSyncPayloadDetector();
  final now = DateTime(2024, 1, 1);

  test('同じpayloadのレコードが既にあれば重複と判定する', () {
    final existing = SyncableRecord(payload: const {'unit': 'mat_numeros_1'}, updatedAt: now);
    final candidate = SyncableRecord(
      payload: const {'unit': 'mat_numeros_1'},
      updatedAt: now.add(const Duration(minutes: 1)),
    );
    expect(
      detector.isDuplicate(candidate: candidate, records: [existing]),
      isTrue,
    );
  });

  test('payloadが異なれば重複と判定しない', () {
    final existing = SyncableRecord(payload: const {'unit': 'mat_numeros_1'}, updatedAt: now);
    final candidate = SyncableRecord(payload: const {'unit': 'mat_numeros_2'}, updatedAt: now);
    expect(
      detector.isDuplicate(candidate: candidate, records: [existing]),
      isFalse,
    );
  });

  test('レコードが空なら重複と判定しない', () {
    final candidate = SyncableRecord(payload: const {'unit': 'mat_numeros_1'}, updatedAt: now);
    expect(
      detector.isDuplicate(candidate: candidate, records: const []),
      isFalse,
    );
  });
}
