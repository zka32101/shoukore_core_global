import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const ptProfile = RegionalProfile(
    locale: 'pt_BR',
    ageOfConsent: 12,
    guardianConsentRequired: true,
    dailyResetHour: 0,
    timeZone: 'America/Sao_Paulo',
    screenTimeLimitMinutes: 0,
    profilingAdsAllowed: false,
  );

  group('DailyBoundary', () {
    test('dailyResetHour=0 の場合は日付がそのままミッション日になる', () {
      const boundary = DailyBoundary(ptProfile);
      final day = boundary.missionDayOf(DateTime.utc(2026, 10, 14, 23, 59));
      expect(day, DateTime.utc(2026, 10, 14));
    });

    test('固定5:00ではなくprofileのdailyResetHourを基準にする', () {
      const jaProfile = RegionalProfile(
        locale: 'ja',
        ageOfConsent: 16,
        guardianConsentRequired: false,
        dailyResetHour: 5,
        timeZone: 'Asia/Tokyo',
        screenTimeLimitMinutes: 0,
        profilingAdsAllowed: false,
      );
      const boundary = DailyBoundary(jaProfile);
      // 5:00前は前日扱いになる。
      final beforeReset = boundary.missionDayOf(DateTime.utc(2026, 10, 14, 4, 59));
      expect(beforeReset, DateTime.utc(2026, 10, 13));
      final afterReset = boundary.missionDayOf(DateTime.utc(2026, 10, 14, 5, 0));
      expect(afterReset, DateTime.utc(2026, 10, 14));
    });

    test('isSameMissionDay は同じミッション日かどうかを判定する', () {
      const boundary = DailyBoundary(ptProfile);
      expect(
        boundary.isSameMissionDay(
          DateTime.utc(2026, 10, 14, 1),
          DateTime.utc(2026, 10, 14, 23),
        ),
        isTrue,
      );
      expect(
        boundary.isSameMissionDay(
          DateTime.utc(2026, 10, 14, 23, 59),
          DateTime.utc(2026, 10, 15, 0, 1),
        ),
        isFalse,
      );
    });
  });

  group('DailyMissionRules', () {
    const boundary = DailyBoundary(ptProfile);
    const rules = DailyMissionRules(targetCount: 3, rewardCoins: 10);

    test('問題を解くたびにcompletedCountが増える', () {
      final now = DateTime.utc(2026, 10, 14, 10);
      var state = rules.recordCompletion(previous: null, now: now, boundary: boundary);
      expect(state.completedCount, 1);
      state = rules.recordCompletion(previous: state, now: now, boundary: boundary);
      expect(state.completedCount, 2);
    });

    test('目標達成でisRewardEligibleがtrueになる', () {
      final now = DateTime.utc(2026, 10, 14, 10);
      var state = rules.recordCompletion(previous: null, now: now, boundary: boundary);
      state = rules.recordCompletion(previous: state, now: now, boundary: boundary);
      expect(rules.isRewardEligible(state), isFalse);
      state = rules.recordCompletion(previous: state, now: now, boundary: boundary);
      expect(rules.isRewardEligible(state), isTrue);
      state = rules.claimReward(state);
      expect(rules.isRewardEligible(state), isFalse);
    });

    test('ミッション日が変わると進捗はリセットされる', () {
      final day1 = DateTime.utc(2026, 10, 14, 10);
      final day2 = DateTime.utc(2026, 10, 15, 10);
      var state = rules.recordCompletion(previous: null, now: day1, boundary: boundary);
      state = rules.recordCompletion(previous: state, now: day1, boundary: boundary);
      expect(state.completedCount, 2);

      state = rules.recordCompletion(previous: state, now: day2, boundary: boundary);
      expect(state.completedCount, 1);
      expect(state.missionDay, DateTime.utc(2026, 10, 15));
    });
  });

  group('CoinWallet', () {
    test('earn/spendで残高が増減する', () {
      const wallet = CoinWallet();
      final earned = wallet.earn(10);
      expect(earned.balance, 10);
      final spent = earned.spend(4);
      expect(spent.balance, 6);
    });

    test('残高不足でspendすると例外', () {
      const wallet = CoinWallet(balance: 5);
      expect(() => wallet.spend(10), throwsStateError);
    });

    test('負の数ではearn/spendできない', () {
      const wallet = CoinWallet(balance: 5);
      expect(() => wallet.earn(-1), throwsArgumentError);
      expect(() => wallet.spend(-1), throwsArgumentError);
    });
  });

  group('GrowthStageCalculator', () {
    const calc = GrowthStageCalculator();

    test('累計正答数に応じて段階が進む', () {
      expect(calc.stageFor(0), GrowthStage.egg);
      expect(calc.stageFor(10), GrowthStage.baby);
      expect(calc.stageFor(50), GrowthStage.child);
      expect(calc.stageFor(150), GrowthStage.adult);
    });

    test('閾値はコンストラクタで差し替え可能', () {
      const custom = GrowthStageCalculator(thresholds: [1, 2, 3]);
      expect(custom.stageFor(1), GrowthStage.baby);
      expect(custom.stageFor(3), GrowthStage.adult);
    });
  });
}
