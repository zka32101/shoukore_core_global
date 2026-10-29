import 'coin_earning_cap_per_day.dart';
import 'daily_boundary.dart';

/// 日単位でリセットされるコイン獲得量の記録状態。`DailyMissionState`と同様、
/// `day`(ミッション日)と、その日にすでに獲得した額を保持する。
class DailyCoinEarningState {
  const DailyCoinEarningState({required this.day, this.earnedToday = 0});

  final DateTime day;
  final int earnedToday;
}

/// デイリーミッション報酬とは別枠のボーナスコイン（例: 解説を読むと
/// もらえるコイン）について、1日あたりの獲得上限を日付境界（
/// `DailyBoundary`、地域ごとのリセット時刻）を踏まえて判定する。
/// `CoinEarningCapPerDay`（上限判定そのもの）に、`DailyMissionRules`と
/// 同様の日替わりリセット機構を組み合わせた純関数。
class DailyCoinEarningRules {
  const DailyCoinEarningRules({this.dailyCap = 20});

  final int dailyCap;

  CoinEarningCapPerDay get _cap => CoinEarningCapPerDay(dailyCap: dailyCap);

  /// [requested]コインの獲得を試みる。[previous]が現在の日付境界と
  /// 異なる日であれば0獲得から数え直す。[dailyCap]を超える分は切り捨て、
  /// 実際に獲得できた額(`granted`)と更新後の状態(`nextState`)を返す。
  ({int granted, DailyCoinEarningState nextState}) recordEarning({
    required DailyCoinEarningState? previous,
    required int requested,
    required DateTime now,
    required DailyBoundary boundary,
  }) {
    final today = boundary.missionDayOf(now);
    final base = (previous == null || !boundary.isSameMissionDay(previous.day, today))
        ? DailyCoinEarningState(day: today)
        : previous;

    final earningState = CoinEarningState(earnedToday: base.earnedToday);
    final remaining = dailyCap - earningState.earnedToday;
    final granted = requested.clamp(0, remaining < 0 ? 0 : remaining);
    final nextEarningState = _cap.recordEarning(earningState, granted, now);

    return (
      granted: granted,
      nextState: DailyCoinEarningState(day: today, earnedToday: nextEarningState.earnedToday),
    );
  }
}
