import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('GuardianApprovalRequestDuplicateDetector', () {
    const detector = GuardianApprovalRequestDuplicateDetector();
    final baseTime = DateTime(2026, 1, 1, 10, 0, 0);

    test('同一payloadかつ短時間内の既存申請があれば重複と判定する', () {
      final existing = GuardianApprovalRequest(
        id: 'r1',
        payload: const {'unitId': 'u1'},
        requestedAt: baseTime,
      );
      final candidate = GuardianApprovalRequest(
        id: 'r2',
        payload: const {'unitId': 'u1'},
        requestedAt: baseTime.add(const Duration(minutes: 5)),
      );

      expect(
        detector.isDuplicate(candidate: candidate, requests: [existing]),
        isTrue,
      );
    });

    test('payloadが異なれば重複と判定しない', () {
      final existing = GuardianApprovalRequest(
        id: 'r1',
        payload: const {'unitId': 'u1'},
        requestedAt: baseTime,
      );
      final candidate = GuardianApprovalRequest(
        id: 'r2',
        payload: const {'unitId': 'u2'},
        requestedAt: baseTime.add(const Duration(minutes: 5)),
      );

      expect(
        detector.isDuplicate(candidate: candidate, requests: [existing]),
        isFalse,
      );
    });

    test('duplicateWindowを超えていれば重複と判定しない', () {
      final existing = GuardianApprovalRequest(
        id: 'r1',
        payload: const {'unitId': 'u1'},
        requestedAt: baseTime,
      );
      final candidate = GuardianApprovalRequest(
        id: 'r2',
        payload: const {'unitId': 'u1'},
        requestedAt: baseTime.add(const Duration(minutes: 20)),
      );

      expect(
        detector.isDuplicate(candidate: candidate, requests: [existing]),
        isFalse,
      );
    });

    test('自分自身のidとは重複と判定しない', () {
      final candidate = GuardianApprovalRequest(
        id: 'r1',
        payload: const {'unitId': 'u1'},
        requestedAt: baseTime,
      );

      expect(
        detector.isDuplicate(candidate: candidate, requests: [candidate]),
        isFalse,
      );
    });
  });
}
