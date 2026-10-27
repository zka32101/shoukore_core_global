/// 問題の解説をどの詳しさで提示すべきかを判定する純関数。同一問題・
/// 同一単元で誤答を繰り返しているほど、より丁寧で詳しい解説段階を
/// 選ぶ。「教科書より分かりやすい丁寧な解説」という共通要件向け。
/// 実際の解説文の内容・表示自体はアプリ側の責務とする。
enum ExplanationDepth { brief, standard, detailed }

class ExplanationDepthSelector {
  const ExplanationDepthSelector({
    this.detailedThreshold = 2,
  }) : assert(detailedThreshold > 0);

  /// 連続誤答数がこの値以上になったら[ExplanationDepth.detailed]を
  /// 選ぶ。
  final int detailedThreshold;

  /// [consecutiveIncorrectCount]（同一問題・単元での連続誤答数）が
  /// [detailedThreshold]以上であれば[ExplanationDepth.detailed]、
  /// 1回でも誤答していれば[ExplanationDepth.standard]、それ以外
  /// （初見または正答のみ）であれば[ExplanationDepth.brief]を返す。
  ExplanationDepth selectDepth(int consecutiveIncorrectCount) {
    if (consecutiveIncorrectCount >= detailedThreshold) {
      return ExplanationDepth.detailed;
    }
    if (consecutiveIncorrectCount > 0) {
      return ExplanationDepth.standard;
    }
    return ExplanationDepth.brief;
  }
}
