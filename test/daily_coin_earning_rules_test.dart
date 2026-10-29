import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const rules = DailyCoinEarningRules(dailyCap: 20);
  const profile = RegionalProfile(
    locale: 'pt_BR',
    ageOfConsent: 13,
    guardianConsentRequired: true,
    dailyResetHour: 5,
    timeZone: 'America/Sao_Paulo',
    screenTimeLimitMinutes: 0,
    profilingAdsAllowed: false,
  );
  final boundary = DailyBoundary(profile);

  test('初回の獲得は満額付与される', () {
    final now = DateTime.utc(2026, 10, 29, 10);
    final result = rules.recordEarning(
      previous: null,
      requested: 2,
      now: now,
      boundary: boundary,
    );
    expect(result.granted, 2);
    expect(result.nextState.earnedToday, 2);
  });

  test('同じ日の間は累積され、上限を超える分は切り捨てられる', () {
    final day = DateTime.utc(2026, 10, 29, 10);
    var state = rules
        .recordEarning(previous: null, requested: 18, now: day, boundary: boundary)
        .nextState;
    expect(state.earnedToday, 18);

    // 残り枠は2だが3を要求 → 2しか付与されない。
    final result = rules.recordEarning(
      previous: state,
      requested: 3,
      now: day.add(const Duration(minutes: 1)),
      boundary: boundary,
    );
    expect(result.granted, 2);
    expect(result.nextState.earnedToday, 20);
    state = result.nextState;

    // すでに上限に達しているので、以降は何も付与されない。
    final capped = rules.recordEarning(
      previous: state,
      requested: 5,
      now: day.add(const Duration(minutes: 2)),
      boundary: boundary,
    );
    expect(capped.granted, 0);
    expect(capped.nextState.earnedToday, 20);
  });

  test('日付境界(dailyResetHour)を跨ぐと0からリセットされる', () {
    final day1 = DateTime.utc(2026, 10, 29, 10);
    final maxedOut = rules
        .recordEarning(previous: null, requested: 20, now: day1, boundary: boundary)
        .nextState;
    expect(maxedOut.earnedToday, 20);

    // 翌日(dailyResetHour=5を過ぎた時刻)に進める。
    final day2 = DateTime.utc(2026, 10, 30, 10);
    final result = rules.recordEarning(
      previous: maxedOut,
      requested: 2,
      now: day2,
      boundary: boundary,
    );
    expect(result.granted, 2);
    expect(result.nextState.earnedToday, 2);
    expect(result.nextState.day, boundary.missionDayOf(day2));
  });
}
