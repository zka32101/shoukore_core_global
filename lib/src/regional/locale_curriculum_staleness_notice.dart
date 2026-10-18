/// `DeviceLocaleSuggester`が提案したロケールに実際に切り替わった後、
/// そのロケール向けのカリキュラムが一度も読み込まれていないことに
/// 気づけるようにする純関数。`DeviceLocaleSuggester`自体はロケール文字列
/// の提案のみを行い、実際にカリキュラムが読み込まれたかは見ないため、
/// 本クラスがその整合性を確認する。実際のカリキュラム読み込みの再試行・
/// エラー表示はアプリ側の責務とする。
class LocaleCurriculumStalenessNotice {
  const LocaleCurriculumStalenessNotice();

  /// [currentLocale]（現在のロケール）と[lastLoadedCurriculumLocale]
  /// （最後にカリキュラムを読み込んだロケール、未読み込みは`null`）が
  /// 一致しない場合、現在のロケール向けのカリキュラムが未読み込みである
  /// と判定する。
  bool isCurriculumStale({
    required String currentLocale,
    required String? lastLoadedCurriculumLocale,
  }) {
    return currentLocale != lastLoadedCurriculumLocale;
  }
}
