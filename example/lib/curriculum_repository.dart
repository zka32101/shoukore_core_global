import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shoukore_core_global/shoukore_core_global.dart';

/// コア(`shoukore_core_global`)が同梱するカリキュラムJSON/regional profileを
/// パッケージアセット経由で読み込む。アプリ側はファイルパスを意識しない。
class CurriculumRepository {
  const CurriculumRepository();

  String localeKey(Locale locale) {
    if (locale.languageCode == 'pt') return 'pt_BR';
    return locale.languageCode;
  }

  Future<CurriculumData> loadCurriculum(Locale locale) async {
    final content = await rootBundle
        .loadString('packages/shoukore_core_global/curriculum/${localeKey(locale)}.json');
    return parseCurriculum(content);
  }

  Future<RegionalProfile> loadRegionalProfile(Locale locale) async {
    final content = await rootBundle
        .loadString('packages/shoukore_core_global/regional/${localeKey(locale)}.yaml');
    return parseRegionalProfile(content);
  }
}
