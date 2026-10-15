import '../models/models.dart';

/// `Mastery`一覧から、次に学習すべき単元を提案する純関数。未習得・弱点が強い
/// 単元（`score`が低い単元）を優先する。カリキュラムの単元順序や解禁状態
/// （`Entitlement`）は関与せず、呼び出し側が候補の`unitId`一覧を渡す。
class UnitRecommendation {
  const UnitRecommendation();

  /// [unitIds]のうち、[masteryByUnitId]に記録がない（未学習）単元、または
  /// `score`が低い単元を優先する順に並べ替えて返す。未学習の単元は`score: 0`
  /// として扱われるため、既習の低スコア単元より優先される保証はなく、同じ
  /// `score`同士では[unitIds]に渡した順序を保つ（安定ソート）。
  List<String> recommend({
    required List<String> unitIds,
    required Map<String, Mastery> masteryByUnitId,
  }) {
    final scored = unitIds
        .map((id) => (id: id, score: masteryByUnitId[id]?.score ?? 0.0))
        .toList();
    scored.sort((a, b) => a.score.compareTo(b.score));
    return scored.map((e) => e.id).toList();
  }

  /// [recommend]の先頭（最も優先すべき単元）を返す。[unitIds]が空なら`null`。
  String? topPick({
    required List<String> unitIds,
    required Map<String, Mastery> masteryByUnitId,
  }) {
    final recommended = recommend(unitIds: unitIds, masteryByUnitId: masteryByUnitId);
    return recommended.isEmpty ? null : recommended.first;
  }
}
