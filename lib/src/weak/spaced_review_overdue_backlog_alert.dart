/// `SpacedReviewScheduler.dueQuestionIds`で復習期限が来ていると判定された
/// 問題の件数が一定数を超えて積み上がっている状態を検知する純関数。
/// `SpacedReviewScheduler`自体は期限到来IDの抽出のみを行い、その件数が
/// 積み上がっているかは見ない。`WeakNoteBacklogSizeAlert`は弱点ノート
/// （誤解タイプの集計）単位の積み上がりを見るものであり、間隔反復の
/// 復習待ち件数とは別軸である。実際の「まとめて復習しよう」案内の表示は
/// アプリ側の責務とする。
class SpacedReviewOverdueBacklogAlert {
  const SpacedReviewOverdueBacklogAlert({this.backlogThreshold = 10})
      : assert(backlogThreshold > 0);

  /// 復習期限到来の件数がこの数以上になったら積み上がりとみなす。
  final int backlogThreshold;

  /// [dueQuestionIds]（`SpacedReviewScheduler.dueQuestionIds`の結果）の
  /// 件数が[backlogThreshold]以上であれば、積み上がり状態と判定する。
  bool isBacklogged(List<String> dueQuestionIds) {
    return dueQuestionIds.length >= backlogThreshold;
  }
}
