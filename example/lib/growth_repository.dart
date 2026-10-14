import 'package:shoukore_core_global/shoukore_core_global.dart';

/// growthモジュール（`DailyMissionRules`/`CoinWallet`/`GrowthStageCalculator`）は
/// いずれも純関数のみを提供し、永続化先を規定しない。サンプルアプリでは端末内の
/// 簡易な状態保持（再起動で消える）としてここに閉じ込め、UI結合確認に専念する。
/// 本番アプリでは`ProgressStore`実装と同様に永続化層を用意するのが望ましい。
class GrowthRepository {
  GrowthRepository({
    required this.clock,
    required this.profile,
    this.missionRules = const DailyMissionRules(),
    this.stageCalculator = const GrowthStageCalculator(),
  }) : boundary = DailyBoundary(profile);

  final Clock clock;
  final RegionalProfile profile;
  final DailyMissionRules missionRules;
  final GrowthStageCalculator stageCalculator;
  final DailyBoundary boundary;

  DailyMissionState? _missionState;
  CoinWallet _wallet = const CoinWallet();
  int _totalCorrectAnswers = 0;

  DailyMissionState get missionState =>
      _missionState ?? DailyMissionState(missionDay: boundary.currentMissionDay(clock));
  CoinWallet get wallet => _wallet;
  GrowthStage get stage => stageCalculator.stageFor(_totalCorrectAnswers);

  /// 1問正解するたびに呼ぶ。ミッション進捗を進め、目標達成していれば報酬を自動付与する。
  void recordCorrectAnswer() {
    _totalCorrectAnswers += 1;
    _missionState = missionRules.recordCompletion(
      previous: _missionState,
      now: clock.now(),
      boundary: boundary,
    );
    if (missionRules.isRewardEligible(_missionState!)) {
      _wallet = _wallet.earn(missionRules.rewardCoins);
      _missionState = missionRules.claimReward(_missionState!);
    }
  }
}
