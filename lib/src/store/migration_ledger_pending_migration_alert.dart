/// アプリが認識しているマイグレーションのうち、`MigrationLedger`に
/// 「適用済み」として記録されていないものが長期間残っている（実行漏れの
/// 疑いがある）状態を検知する純関数。`MigrationLedgerRollbackGuard`は
/// 逆方向（台帳に記録されているが現在のアプリが認識していないID）を
/// 見るため、認識しているが未適用のままのIDは見ない。実際の再実行・
/// 警告表示はアプリ側の責務とする。
class MigrationLedgerPendingMigrationAlert {
  const MigrationLedgerPendingMigrationAlert();

  /// [knownMigrationIds]（現在のアプリが認識しているID一覧）のうち、
  /// [appliedMigrationIds]（台帳に適用済みと記録されているID一覧）に
  /// 含まれないものを、未適用のまま残っているマイグレーションとして返す。
  Set<String> findPendingMigrationIds({
    required Set<String> knownMigrationIds,
    required Set<String> appliedMigrationIds,
  }) {
    return knownMigrationIds.difference(appliedMigrationIds);
  }

  /// 未適用のマイグレーションが1件以上存在するかを判定する。
  bool hasPendingMigrations({
    required Set<String> knownMigrationIds,
    required Set<String> appliedMigrationIds,
  }) {
    return findPendingMigrationIds(
      knownMigrationIds: knownMigrationIds,
      appliedMigrationIds: appliedMigrationIds,
    ).isNotEmpty;
  }
}
