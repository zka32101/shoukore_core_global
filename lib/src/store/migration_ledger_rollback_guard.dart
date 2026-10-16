/// `MigrationLedger`に「適用済み」として記録されているマイグレーション
/// IDの中に、現在のアプリが知らない（アプリのダウングレード等で存在し得る）
/// ものが含まれていないかを判定する純関数。`MigrationLedger`自体は適用
/// 済みかどうかの記録・問い合わせのみを担うため、本クラスが現在のアプリが
/// 認識しているマイグレーションID一覧との差分を見る。実際の警告表示・
/// データ整合性の復旧処理はアプリ側の責務とする。
class MigrationLedgerRollbackGuard {
  const MigrationLedgerRollbackGuard();

  /// [appliedMigrationIds]（台帳に適用済みと記録されているID一覧）のうち、
  /// [knownMigrationIds]（現在のアプリが認識しているID一覧）に含まれない
  /// ものが1件以上あれば、ダウングレード等による異常な状態として警告対象
  /// と判定する。
  bool hasUnknownAppliedMigrations({
    required Set<String> appliedMigrationIds,
    required Set<String> knownMigrationIds,
  }) {
    return appliedMigrationIds.any((id) => !knownMigrationIds.contains(id));
  }
}
