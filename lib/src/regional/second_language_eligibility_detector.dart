/// 第二言語として英語を選択可能にすべきかどうかを判定する純関数。
/// 主言語が既に英語であるロケールでは、第二言語としての英語選択は
/// 意味を持たないため対象外とする。実際の言語選択UI・翻訳コンテンツ
/// の提供自体はアプリ側の責務とする。
class SecondLanguageEligibilityDetector {
  const SecondLanguageEligibilityDetector({
    this.primaryLanguageCode = 'en',
  });

  /// 第二言語として提示しない主言語コード（通常は英語自体）。
  final String primaryLanguageCode;

  /// [localePrimaryLanguageCode]（ロケールの主言語コード、例: 'ja',
  /// 'pt', 'en'）が[primaryLanguageCode]と異なれば、第二言語として
  /// 英語を選択可能と判定する。
  bool isEligible(String localePrimaryLanguageCode) {
    return localePrimaryLanguageCode != primaryLanguageCode;
  }
}
