import 'package:yaml/yaml.dart';

import '../models/models.dart';

/// `regional/{locale}.yaml` の内容から [RegionalProfile] を組み立てる。
/// ファイル読み込み自体（assetかファイルか）はアプリ側の責務とし、ここでは文字列を受け取るのみ。
RegionalProfile parseRegionalProfile(String yamlContent) {
  final doc = loadYaml(yamlContent) as YamlMap;
  return RegionalProfile(
    locale: doc['locale'] as String,
    ageOfConsent: doc['ageOfConsent'] as int,
    guardianConsentRequired: doc['guardianConsentRequired'] as bool,
    dailyResetHour: doc['dailyResetHour'] as int,
    timeZone: doc['timeZone'] as String,
    screenTimeLimitMinutes: (doc['screenTimeLimitMinutes'] as int?) ?? 0,
    profilingAdsAllowed: (doc['profilingAdsAllowed'] as bool?) ?? false,
  );
}
