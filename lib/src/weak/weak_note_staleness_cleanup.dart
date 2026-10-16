import 'weak_notes.dart';

/// `WeakNote`が長期間（最後に誤答が記録されてから一定日数）更新されずに
/// 残っている場合、整理（アーカイブ・非表示化）対象にすべきかを判定する
/// 純関数。`WeakNotesReviewScheduler`（復習タイミングの計算）とは異なり、
/// 復習されずに放置され続けた古いノートの掃除を扱う。実際のアーカイブ・
/// 削除処理はアプリ側の責務とする。
class WeakNoteStalenessCleanup {
  const WeakNoteStalenessCleanup({this.staleAfter = const Duration(days: 90)});

  /// 最後の更新からこの期間を超えると整理対象とみなす。
  final Duration staleAfter;

  /// [note]に弱点が残っており（[WeakNote.hasWeakness]）、かつ
  /// [lastUpdatedAt]からの経過が[staleAfter]を超えていれば整理対象と
  /// 判定する。弱点が既に解消済み（`hasWeakness`が`false`）の場合は
  /// 対象外とする。
  bool shouldCleanUp({
    required WeakNote note,
    required DateTime lastUpdatedAt,
    required DateTime now,
  }) {
    if (!note.hasWeakness) return false;
    return now.difference(lastUpdatedAt) > staleAfter;
  }
}
