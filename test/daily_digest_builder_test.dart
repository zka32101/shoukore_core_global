import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const profile = RegionalProfile(
    locale: 'ja',
    ageOfConsent: 16,
    guardianConsentRequired: false,
    dailyResetHour: 0,
    timeZone: 'Asia/Tokyo',
    screenTimeLimitMinutes: 0,
    profilingAdsAllowed: false,
  );
  const boundary = DailyBoundary(profile);

  test('今日分の記録のみ集計し、ストリークはGrowthSnapshotから引き継ぐ', () async {
    final clock = FixedClock(DateTime.utc(2026, 10, 14, 12));
    final store = _FakeProgressStore({
      'mat_sub_2': [
        Attempt(
          questionId: 'q1',
          unitId: 'mat_sub_2',
          correct: true,
          chosenId: '5',
          answeredAt: DateTime.utc(2026, 10, 14, 9),
        ),
        Attempt(
          questionId: 'q2',
          unitId: 'mat_sub_2',
          correct: false,
          chosenId: '3',
          answeredAt: DateTime.utc(2026, 10, 14, 10),
        ),
        Attempt(
          questionId: 'q3',
          unitId: 'mat_sub_2',
          correct: true,
          chosenId: '5',
          answeredAt: DateTime.utc(2026, 10, 13, 9), // 昨日分は含めない
        ),
      ],
    });

    const builder = DailyDigestBuilder();
    final digest = await builder.build(
      progressStore: store,
      unitIds: ['mat_sub_2'],
      growthSnapshot: const GrowthSnapshot(currentStreakDays: 5),
      clock: clock,
      boundary: boundary,
    );

    expect(digest.attemptsToday, 2);
    expect(digest.correctToday, 1);
    expect(digest.accuracy, closeTo(0.5, 1e-9));
    expect(digest.currentStreakDays, 5);
    expect(digest.day, DateTime.utc(2026, 10, 14));
  });

  test('今日の記録が無ければattemptsToday/correctTodayは0', () async {
    final clock = FixedClock(DateTime.utc(2026, 10, 14));
    final store = _FakeProgressStore({'mat_sub_2': []});

    const builder = DailyDigestBuilder();
    final digest = await builder.build(
      progressStore: store,
      unitIds: ['mat_sub_2'],
      growthSnapshot: GrowthSnapshot.initial,
      clock: clock,
      boundary: boundary,
    );

    expect(digest.attemptsToday, 0);
    expect(digest.correctToday, 0);
    expect(digest.accuracy, 0);
  });
}

class _FakeProgressStore implements ProgressStore {
  _FakeProgressStore(this._attemptsByUnit);

  final Map<String, List<Attempt>> _attemptsByUnit;

  @override
  Future<void> recordAttempt(Attempt attempt) async {}

  @override
  Future<List<Attempt>> getAttempts(String unitId, {int? limit}) async =>
      _attemptsByUnit[unitId] ?? [];

  @override
  Future<Mastery> getMastery(String unitId) async =>
      Mastery(unitId: unitId, score: 0, lastPracticedAt: null);

  @override
  Future<List<Mastery>> getAllMastery() async => [];

  @override
  Future<void> clearAll() async {}
}
