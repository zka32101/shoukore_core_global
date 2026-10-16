import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

PendingSyncItem _item(String id) => PendingSyncItem(
      id: id,
      payload: const {},
      createdAt: DateTime(2024, 1, 1),
    );

void main() {
  const alert = SyncQueueBacklogAlert(backlogThreshold: 3);

  test('件数が閾値未満ならアラートしない', () {
    final items = [_item('1'), _item('2')];
    expect(alert.shouldAlert(items), isFalse);
  });

  test('件数が閾値以上ならアラートする', () {
    final items = [_item('1'), _item('2'), _item('3')];
    expect(alert.shouldAlert(items), isTrue);
  });

  test('空のキューはアラートしない', () {
    expect(alert.shouldAlert(const []), isFalse);
  });
}
