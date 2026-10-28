import '../models/models.dart';

/// 正答率（`Mastery.score`）が一定を下回る場合に、次の出題でヒントを
/// 自動的に表示すべきかを判定する純関数。ヒントの内容・表示UI・ヒント
/// 利用自体の記録はアプリ側の責務とする。`QuestionHintOverrelianceDetector`
/// は「ヒントを使いすぎていないか」を見るもので、本クラスとは逆向き
/// （「ヒントが必要そうか」）の判定。
class AutoHintPolicy {
  const AutoHintPolicy({this.accuracyThreshold = 0.6}) : assert(accuracyThreshold >= 0);

  /// この正答率を下回ったら自動ヒント表示の対象とする。
  final double accuracyThreshold;

  /// [mastery]が`null`（未学習）、または`score`が[accuracyThreshold]未満
  /// であれば自動ヒント表示が必要と判定する。
  bool shouldShowHint(Mastery? mastery) {
    if (mastery == null) return true;
    return mastery.score < accuracyThreshold;
  }
}
