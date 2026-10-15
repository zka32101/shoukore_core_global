import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const resolver = OfflineSyncConflictResolver();

  test('localの方が新しければlocalを採用する', () {
    final local = SyncableRecord(payload: const {'v': 'local'}, updatedAt: DateTime(2024, 1, 2));
    final remote = SyncableRecord(payload: const {'v': 'remote'}, updatedAt: DateTime(2024, 1, 1));

    expect(resolver.resolve(local: local, remote: remote).payload['v'], 'local');
  });

  test('remoteの方が新しければremoteを採用する', () {
    final local = SyncableRecord(payload: const {'v': 'local'}, updatedAt: DateTime(2024, 1, 1));
    final remote = SyncableRecord(payload: const {'v': 'remote'}, updatedAt: DateTime(2024, 1, 2));

    expect(resolver.resolve(local: local, remote: remote).payload['v'], 'remote');
  });

  test('同時刻ならremoteを優先する', () {
    final sameTime = DateTime(2024, 1, 1);
    final local = SyncableRecord(payload: const {'v': 'local'}, updatedAt: sameTime);
    final remote = SyncableRecord(payload: const {'v': 'remote'}, updatedAt: sameTime);

    expect(resolver.resolve(local: local, remote: remote).payload['v'], 'remote');
  });
}
