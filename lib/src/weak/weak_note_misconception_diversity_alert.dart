import 'weak_notes.dart';

/// 1つの単元の弱点ノートが、同時に多種類の誤解タイプに広がっている状態
/// （誤解の多様性）を検知する純関数。`WeakNoteBacklogSizeAlert`は単元を
/// 横断した弱点ノートの件数の積み上がりのみを見るため、1つの単元内で
/// 誤解タイプがどれだけ多岐にわたっているかは見ない。
/// `WeakNoteMisconceptionRelapse`やstalenessは時間軸（再発・放置）のみを
/// 見るため、誤解タイプの種類数という別軸は見ない。実際の「基礎から
/// 見直そう」案内の表示はアプリ側の責務とする。
class WeakNoteMisconceptionDiversityAlert {
  const WeakNoteMisconceptionDiversityAlert({this.diversityThreshold = 3})
      : assert(diversityThreshold > 0);

  /// 誤解タイプの種類数がこの件数以上であれば多様化していると判定する。
  final int diversityThreshold;

  /// [note]の誤解タイプの種類数が[diversityThreshold]以上であれば
  /// アラートすべきと判定する。
  bool isDiverse(WeakNote note) {
    return note.misconceptionCounts.length >= diversityThreshold;
  }
}
