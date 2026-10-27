import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('GuardianTaskApprovalGate', () {
    const gate = GuardianTaskApprovalGate(
      burstThreshold: 3,
      burstWindow: Duration(minutes: 1),
    );
    final now = DateTime(2026, 1, 1, 12, 0, 0);

    test('短時間に閾値以上完了していれば承認が必要', () {
      final timestamps = [
        now.subtract(const Duration(seconds: 10)),
        now.subtract(const Duration(seconds: 20)),
        now.subtract(const Duration(seconds: 30)),
      ];
      expect(gate.requiresApproval(timestamps, now), isTrue);
    });

    test('窓の外の完了は数えない', () {
      final timestamps = [
        now.subtract(const Duration(minutes: 10)),
        now.subtract(const Duration(minutes: 20)),
        now.subtract(const Duration(seconds: 10)),
      ];
      expect(gate.requiresApproval(timestamps, now), isFalse);
    });
  });
}
