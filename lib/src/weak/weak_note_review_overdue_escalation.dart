import '../growth/daily_boundary.dart';
import 'weak_notes_review_scheduler.dart';

/// `WeakNotesReviewScheduler`が算出した復習期限を大幅に超えて放置されて
/// いる弱点単元に気づけるようにする純関数。`WeakNotesReviewScheduler`
/// 自体は「次の復習日」の算出・期限超過の有無の判定のみを行い、期限
/// 超過がどれだけ長引いているかは見ないため、本クラスが独立してその
/// 判定を行う。実際のエスカレーション表示・優先的な出題はアプリ側の
/// 責務とする。
class WeakNoteReviewOverdueEscalation {
  const WeakNoteReviewOverdueEscalation({this.overdueThreshold = 7});

  /// 復習期限（`nextReviewDay`）からこの日数を超えて未復習であれば、
  /// 長期放置とみなす。
  final int overdueThreshold;

  /// [state]の`nextReviewDay`が設定されており、[now]時点でその期限から
  /// [overdueThreshold]日を超えて過ぎていれば、長期放置とみなす。
  bool isOverdueEscalated({
    required WeakNoteReviewState state,
    required DateTime now,
    required DailyBoundary boundary,
  }) {
    final dueDay = state.nextReviewDay;
    if (dueDay == null) return false;

    final today = boundary.missionDayOf(now);
    return today.difference(dueDay).inDays > overdueThreshold;
  }
}
