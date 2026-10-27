/// 問題でイメージ画像ヒントを提示すべきかどうかを判定する純関数。
/// 誤答が続いている問題について、文字だけの解説より直感的な画像
/// ヒントで理解を助けたい場面向け。「わかりやすいイメージ画像」
/// という共通要件に対応する。実際の画像の内容・表示自体はアプリ
/// 側の責務とする。
class ImageHintEligibilityDetector {
  const ImageHintEligibilityDetector({
    this.minConsecutiveIncorrectCount = 1,
  }) : assert(minConsecutiveIncorrectCount > 0);

  /// イメージ画像ヒントを提示する最低連続誤答数。
  final int minConsecutiveIncorrectCount;

  /// [questionHasImageHint]（その問題にイメージ画像ヒントが用意
  /// されているか）が真、かつ[consecutiveIncorrectCount]（同一
  /// 問題での連続誤答数）が[minConsecutiveIncorrectCount]以上で
  /// あれば、提示対象と判定する。
  bool isEligible(bool questionHasImageHint, int consecutiveIncorrectCount) {
    return questionHasImageHint &&
        consecutiveIncorrectCount >= minConsecutiveIncorrectCount;
  }
}
