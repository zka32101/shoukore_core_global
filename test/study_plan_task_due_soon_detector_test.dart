import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  group('StudyPlanTaskDueSoonDetector', () {
    const detector = StudyPlanTaskDueSoonDetector(warningWindowInDays: 1);

    test('期限まで1日以内であれば対象', () {
      final task = StudyPlanTask(
        id: 't1',
        title: '算数の復習',
        dueDate: DateTime(2026, 1, 2),
      );
      expect(detector.isDueSoon(task, DateTime(2026, 1, 1)), isTrue);
    });

    test('期限までまだ余裕があれば対象外', () {
      final task = StudyPlanTask(
        id: 't2',
        title: '国語の復習',
        dueDate: DateTime(2026, 1, 10),
      );
      expect(detector.isDueSoon(task, DateTime(2026, 1, 1)), isFalse);
    });

    test('完了済みなら対象外', () {
      final task = StudyPlanTask(
        id: 't3',
        title: '理科の復習',
        dueDate: DateTime(2026, 1, 2),
        isCompleted: true,
      );
      expect(detector.isDueSoon(task, DateTime(2026, 1, 1)), isFalse);
    });

    test('すでに期限超過していれば対象外', () {
      final task = StudyPlanTask(
        id: 't4',
        title: '社会の復習',
        dueDate: DateTime(2025, 12, 31),
      );
      expect(detector.isDueSoon(task, DateTime(2026, 1, 1)), isFalse);
    });
  });
}
