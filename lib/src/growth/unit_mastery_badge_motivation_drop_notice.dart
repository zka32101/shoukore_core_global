/// 単元マスタリーバッジ解除直後に学習意欲が低下していないかを判定する
/// 純関数。`UnitMasteryBadgeEligibility`自体はマスター済みかどうかの
/// 二値判定のみを行い、マスター達成後の取り組み状況の変化は見ないため、
/// 本クラスが独立してその判定を行う。実際の「もう一度挑戦してみよう」等
/// の呼びかけ表示はアプリ側の責務とする。
class UnitMasteryBadgeMotivationDropNotice {
  const UnitMasteryBadgeMotivationDropNotice({this.inactivityThreshold = const Duration(days: 3)});

  /// マスター達成後、この期間以上その単元の解答がなければ意欲低下とみなす。
  final Duration inactivityThreshold;

  /// [masteredAt]（その単元がマスター済みと判定された時点の直近解答時刻）
  /// から[now]までの経過が[inactivityThreshold]以上であれば、マスター
  /// 直後の学習意欲低下として`true`を返す。
  bool isMotivationDropped({required DateTime masteredAt, required DateTime now}) {
    return now.difference(masteredAt) >= inactivityThreshold;
  }
}
