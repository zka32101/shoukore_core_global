import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const log = ProfileSwitchAuditLog();

  test('初回選択（fromがnull）は記録しない', () {
    expect(log.shouldRecord(fromProfileId: null, toProfileId: 'p1'), isFalse);
  });

  test('同じプロフィールへの切り替えは記録しない', () {
    expect(log.shouldRecord(fromProfileId: 'p1', toProfileId: 'p1'), isFalse);
  });

  test('異なるプロフィールへの切り替えは記録する', () {
    expect(log.shouldRecord(fromProfileId: 'p1', toProfileId: 'p2'), isTrue);
  });
}
