import '../growth/growth_stage.dart';

/// レベルアップ等の成長イベントをきっかけに、アバター変更を促すべきかを
/// 判定する純関数。実際のアバター選択UI・保存・候補一覧の管理はアプリ側の
/// 責務とし、本コアは「前回提案時の進化段階」との比較のみを行う。
class ProfileAvatarRotationSuggester {
  const ProfileAvatarRotationSuggester();

  /// [previousStage]（前回アバター変更を提案した時点の進化段階）から
  /// [currentStage]に進化している場合に、アバター変更を提案すべきと判定する。
  /// [previousStage]が`null`（まだ一度も提案していない）の場合は提案しない
  /// （初回の進化前に不要な提案を出さないため）。
  bool shouldSuggestRotation({
    required GrowthStage? previousStage,
    required GrowthStage currentStage,
  }) {
    if (previousStage == null) return false;
    return currentStage != previousStage;
  }
}
