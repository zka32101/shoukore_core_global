import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ja');
    await initializeDateFormatting('pt_BR');
  });

  const jaProfile = RegionalProfile(
    locale: 'ja',
    ageOfConsent: 16,
    guardianConsentRequired: false,
    dailyResetHour: 5,
    timeZone: 'Asia/Tokyo',
    screenTimeLimitMinutes: 0,
    profilingAdsAllowed: false,
  );

  const ptProfile = RegionalProfile(
    locale: 'pt_BR',
    ageOfConsent: 12,
    guardianConsentRequired: true,
    dailyResetHour: 0,
    timeZone: 'America/Sao_Paulo',
    screenTimeLimitMinutes: 0,
    profilingAdsAllowed: false,
  );

  test('numberはロケールごとの桁区切りで表記する', () {
    final ja = LocaleFormatter(jaProfile);
    final pt = LocaleFormatter(ptProfile);

    expect(ja.number(1234), '1,234');
    expect(pt.number(1234), '1.234');
  });

  test('dateはロケールに応じた表記になる', () {
    final ja = LocaleFormatter(jaProfile);
    final date = DateTime(2026, 10, 14);

    expect(ja.date(date), isNotEmpty);
  });

  test('timeはロケールに応じた表記になる', () {
    final ja = LocaleFormatter(jaProfile);
    final time = DateTime(2026, 10, 14, 9, 30);

    expect(ja.time(time), isNotEmpty);
  });
}
