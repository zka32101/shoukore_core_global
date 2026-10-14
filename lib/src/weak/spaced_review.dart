import '../growth/daily_boundary.dart';

/// 問題1件の復習状態（Leitner方式の箱レベルと次回復習日）。
class ReviewState {
  const ReviewState({required this.questionId, this.boxLevel = 0, this.nextReviewDay});

  final String questionId;
  final int boxLevel;
  final DateTime? nextReviewDay;
}

/// 誤答した問題を間隔反復（spaced repetition）で再提示するタイミングを
/// 計算する純関数モジュール。箱レベルが上がるほど復習間隔が広がり、
/// 誤答すると箱レベル0（最短間隔）に戻る。
class SpacedReviewScheduler {
  const SpacedReviewScheduler();

  /// 箱レベルごとの復習間隔（日）。
  static const List<int> intervalsByBoxLevel = [1, 2, 4, 7, 15];

  ReviewState recordResult({
    required ReviewState? previous,
    required String questionId,
    required bool correct,
    required DateTime now,
    required DailyBoundary boundary,
  }) {
    final currentLevel = previous?.boxLevel ?? 0;
    final nextLevel = correct
        ? (currentLevel + 1).clamp(0, intervalsByBoxLevel.length - 1)
        : 0;
    final today = boundary.missionDayOf(now);
    final nextReviewDay = today.add(Duration(days: intervalsByBoxLevel[nextLevel]));
    return ReviewState(questionId: questionId, boxLevel: nextLevel, nextReviewDay: nextReviewDay);
  }

  /// 現在時点で復習期限が来ている（nextReviewDayが今日以前の）questionIdの一覧。
  List<String> dueQuestionIds({
    required Iterable<ReviewState> states,
    required DateTime now,
    required DailyBoundary boundary,
  }) {
    final today = boundary.missionDayOf(now);
    return states
        .where((s) => s.nextReviewDay != null && !s.nextReviewDay!.isAfter(today))
        .map((s) => s.questionId)
        .toList();
  }
}
