/// `exportSettingsBackup`によるバックアップが長期間作成されていないことに
/// 気づけるようにすべきかを判定する純関数。`exportSettingsBackup`自体は
/// バックアップの生成・復元のみを行い、最終作成時刻の追跡は見ないため、
/// 本クラスがアプリ側が別途記録する最終バックアップ時刻を見る。実際の
/// バックアップ実行の案内はアプリ側の責務とする。
class SettingsBackupStalenessNotice {
  const SettingsBackupStalenessNotice({this.stalenessPeriod = const Duration(days: 90)});

  /// 最終バックアップからこの期間を超えたら催促対象とする。
  final Duration stalenessPeriod;

  /// [lastBackedUpAt]（最終バックアップ時刻、一度も作成していない場合は
  /// `null`）から[now]までの経過が[stalenessPeriod]を超えていれば通知
  /// すべきと判定する。
  bool shouldNotify({required DateTime? lastBackedUpAt, required DateTime now}) {
    if (lastBackedUpAt == null) return true;
    return now.difference(lastBackedUpAt) > stalenessPeriod;
  }
}
