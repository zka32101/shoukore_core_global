import '../growth/daily_boundary.dart';
import 'weak_notes.dart';

/// 弱点単元1件の復習スケジュール状態。
class WeakNoteReviewState {
  const WeakNoteReviewState({required this.unitId, this.nextReviewDay});

  final String unitId;
  final DateTime? nextReviewDay;
}

/// `WeakNotesAnalyzer`が特定した弱点単元を、誤解の頻出度に応じた優先度で
/// 復習すべきタイミングを計算する純関数。`SpacedReview`（問題単位のLeitner式
/// 間隔反復）とは別に、弱点ノート（単元単位の誤解傾向）専用の優先度付けを
/// 行う。誤解回数が多いほど復習間隔を短くするだけで、実際の復習問題の
/// 選定・提示はアプリ側の責務とする。
class WeakNotesReviewScheduler {
  const WeakNotesReviewScheduler();

  /// 誤解回数の閾値ごとの復習間隔（日）。閾値以上の誤解回数があるほど
  /// 間隔が短くなる（優先的に復習させる）。
  static const List<int> _thresholds = [10, 5, 2];
  static const List<int> _intervalsByThreshold = [1, 2, 4];
  static const int _defaultInterval = 7;

  WeakNoteReviewState schedule({
    required WeakNote note,
    required DateTime now,
    required DailyBoundary boundary,
  }) {
    if (!note.hasWeakness) {
      return WeakNoteReviewState(unitId: note.unitId, nextReviewDay: null);
    }
    final totalMisconceptions = note.misconceptionCounts.values.fold(0, (a, b) => a + b);
    var interval = _defaultInterval;
    for (var i = 0; i < _thresholds.length; i++) {
      if (totalMisconceptions >= _thresholds[i]) {
        interval = _intervalsByThreshold[i];
        break;
      }
    }
    final today = boundary.missionDayOf(now);
    return WeakNoteReviewState(
      unitId: note.unitId,
      nextReviewDay: today.add(Duration(days: interval)),
    );
  }

  /// 現在時点で復習期限が来ている（nextReviewDayが今日以前の）unitIdの一覧。
  List<String> dueUnitIds({
    required Iterable<WeakNoteReviewState> states,
    required DateTime now,
    required DailyBoundary boundary,
  }) {
    final today = boundary.missionDayOf(now);
    return states
        .where((s) => s.nextReviewDay != null && !s.nextReviewDay!.isAfter(today))
        .map((s) => s.unitId)
        .toList();
  }
}
