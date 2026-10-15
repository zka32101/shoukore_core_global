/// 本コアが対応済みのロケール（例: `'ja'`, `'pt_BR'`, `'en'`）の中から、
/// OS側の端末ロケール（例: `'pt_PT'`, `'ja_JP'`）に最も近いものを提案する
/// 純関数。初回起動時の既定`RegionalProfile`/l10nロケール選定に使う。
/// 実際のOSロケール取得（`Platform.localeName`等）はアプリ側の責務とする。
class DeviceLocaleSuggester {
  const DeviceLocaleSuggester(this.supportedLocales);

  /// 本コアが対応済みのロケール一覧（例: `['ja', 'pt_BR', 'en']`）。
  final List<String> supportedLocales;

  /// [deviceLocale]に最も近い対応済みロケールを返す。マッチ方針は次の優先順位:
  /// 1. 完全一致（大文字小文字は無視）
  /// 2. 言語コード（`_`より前）が一致するもの（最初に見つかったもの）
  /// 3. 1件も該当しなければ[supportedLocales]の先頭（既定ロケール）
  String suggest(String deviceLocale) {
    if (supportedLocales.isEmpty) {
      throw ArgumentError.value(supportedLocales, 'supportedLocales', 'must not be empty');
    }
    final normalized = deviceLocale.replaceAll('-', '_');

    for (final supported in supportedLocales) {
      if (supported.toLowerCase() == normalized.toLowerCase()) {
        return supported;
      }
    }

    final deviceLanguage = normalized.split('_').first.toLowerCase();
    for (final supported in supportedLocales) {
      final supportedLanguage = supported.split('_').first.toLowerCase();
      if (supportedLanguage == deviceLanguage) {
        return supported;
      }
    }

    return supportedLocales.first;
  }
}
