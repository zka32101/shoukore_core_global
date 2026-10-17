/// `UnitDifficultyOrderValidator`の入力1件分。`Unit.order`（提示順）と、
/// その単元の代表難易度（アプリ側が集計する想定、例えば出題される
/// `Question.difficulty`の平均値）の組。
class UnitDifficultyOrderEntry {
  const UnitDifficultyOrderEntry({
    required this.unitId,
    required this.order,
    required this.difficulty,
  });

  final String unitId;
  final int order;
  final double difficulty;
}

/// 同一学年・同一カテゴリ内で、単元の提示順（`Unit.order`）と難易度の
/// 想定順序（易→難）が逆転していないかを検証する純関数。
/// `tool/check_curriculum.dart`（CIでのID重複・参照整合性チェック）とは
/// 異なり、本クラスは順序と難易度の整合性のみを見る。実際のカリキュラム
/// JSON読み込み・エラー報告先（CI出力等）はアプリ/ツール側の責務とする。
class UnitDifficultyOrderValidator {
  const UnitDifficultyOrderValidator({this.tolerance = 0.0});

  /// 直前の単元よりこの値を超えて難易度が下がっていなければ、逆転とは
  /// 見なさない（小さな揺れを許容するための許容幅）。
  final double tolerance;

  /// [entries]を[UnitDifficultyOrderEntry.order]の昇順で並べたとき、
  /// 直前の単元より難易度が[tolerance]を超えて下がっている単元の
  /// `unitId`一覧を返す（空なら逆転なし）。
  List<String> findOrderInversions(List<UnitDifficultyOrderEntry> entries) {
    final sorted = [...entries]..sort((a, b) => a.order.compareTo(b.order));
    final inverted = <String>[];

    for (var i = 1; i < sorted.length; i++) {
      final previous = sorted[i - 1];
      final current = sorted[i];
      if (current.difficulty < previous.difficulty - tolerance) {
        inverted.add(current.unitId);
      }
    }

    return inverted;
  }
}
