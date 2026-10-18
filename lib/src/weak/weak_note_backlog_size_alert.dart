import 'weak_notes.dart';

/// 未解消の弱点ノートの件数が一定数を超えて増え続けている積み上がり
/// 状態を検知する純関数。`WeakNoteStalenessCleanup`は個々のノートの
/// 最終更新からの経過時間のみを見るため、件数の積み上がりは見ない。
/// 実際の「まとめて復習しよう」案内の表示はアプリ側の責務とする。
class WeakNoteBacklogSizeAlert {
  const WeakNoteBacklogSizeAlert({this.backlogThreshold = 5});

  /// 未解消の弱点ノート件数がこの数以上になったら積み上がりとみなす。
  final int backlogThreshold;

  /// [notes]のうち、[WeakNote.hasWeakness]が`true`のものの件数が
  /// [backlogThreshold]以上であれば、積み上がり状態と判定する。
  bool isBacklogged(List<WeakNote> notes) {
    final unresolvedCount = notes.where((note) => note.hasWeakness).length;
    return unresolvedCount >= backlogThreshold;
  }
}
