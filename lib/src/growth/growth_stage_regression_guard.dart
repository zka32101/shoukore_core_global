import 'growth_stage.dart';

/// `GrowthStageCalculator`が算出した新しい成長段階が、保存済みの段階より
/// 後退（データ不整合やリセット起因等）していないかを判定する純関数。
/// 進化段階は累計正答数に基づき単調に進むべきもので、後退を許すと
/// キャラの見た目が退行してしまうため、更新前に検知する想定。実際の
/// 不整合発生時の対応（データ再計算・ログ送信等）はアプリ側の責務とする。
class GrowthStageRegressionGuard {
  const GrowthStageRegressionGuard();

  /// [newStage]が[storedStage]より後退している（`GrowthStage`の並び順で
  /// インデックスが小さい）場合に`true`を返す。
  bool isRegression({required GrowthStage storedStage, required GrowthStage newStage}) {
    return newStage.index < storedStage.index;
  }
}
