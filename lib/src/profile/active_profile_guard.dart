/// `ProfileStore`で管理するアクティブプロファイルの切替時に、他プロファイルの
/// 学習データを誤って混在させないための軽量ガード。`ProgressStore`/
/// `GrowthStore`/`ScreenTimeStore`等はまだプロファイルIDで分離されていない
/// ため（ADR「ProfileStoreの追加」参照）、アプリ側のRepository層が
/// 「データを読み込んだ時点のプロファイルIDのまま保存しようとしていないか」
/// を保存直前に確認する用途を想定する。
class ActiveProfileGuard {
  const ActiveProfileGuard();

  bool isSameProfile({
    required String? expectedProfileId,
    required String? currentActiveProfileId,
  }) =>
      expectedProfileId == currentActiveProfileId;

  /// [expectedProfileId]（データを読み込んだ時点のプロファイルID）と
  /// [currentActiveProfileId]（保存しようとしている今のアクティブプロファイルID）
  /// が一致しない場合、保存を進めずに`StateError`を投げる。
  void ensureSameProfile({
    required String? expectedProfileId,
    required String? currentActiveProfileId,
  }) {
    if (!isSameProfile(
      expectedProfileId: expectedProfileId,
      currentActiveProfileId: currentActiveProfileId,
    )) {
      throw StateError(
        'active profile changed during operation: '
        'expected "$expectedProfileId" but current active profile is "$currentActiveProfileId"',
      );
    }
  }
}
