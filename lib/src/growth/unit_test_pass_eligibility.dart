import '../models/models.dart';

/// 単元ごとの「まとめテスト」（固定問題数の1回勝負、無限出題の練習とは別の
/// 到達点モード）に合格したかを判定する純関数。`UnitMasteryBadgeEligibility`
/// （直近N件の継続的な正答率を見る）とは異なり、本クラスは`Attempt.mode`が
/// `'test'`のものだけを対象に、直近1回分（最新[requiredQuestions]件）の
/// 正答率だけで判定する（過去の合格・不合格の履歴は見ない。受け直せば
/// 直近の結果に置き換わる）。合否の永続化・通知表示はアプリ側の責務。
class UnitTestPassEligibility {
  const UnitTestPassEligibility({
    this.requiredQuestions = 10,
    this.passAccuracy = 0.8,
  })  : assert(requiredQuestions > 0),
        assert(passAccuracy > 0 && passAccuracy <= 1);

  /// まとめテスト1回分の問題数。
  final int requiredQuestions;

  /// 合格に必要な正答率（直近[requiredQuestions]件中）。
  final double passAccuracy;

  /// [testAttemptsNewestFirst]は該当単元の`mode == 'test'`な`Attempt`のみを
  /// 新しい順に渡す想定（呼び出し側がフィルタ・ソート済みであること）。
  /// まだ[requiredQuestions]件に満たない（＝一度もまとめテストを完走して
  /// いない）場合はfalse。
  bool isPassed(List<Attempt> testAttemptsNewestFirst) {
    if (testAttemptsNewestFirst.length < requiredQuestions) return false;
    final recent = testAttemptsNewestFirst.take(requiredQuestions);
    final correctCount = recent.where((a) => a.correct).length;
    return correctCount / requiredQuestions >= passAccuracy;
  }
}
