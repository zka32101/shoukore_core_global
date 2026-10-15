/// drift以外の一度きりの移行処理（例: 旧シングルプロファイルから複数
/// プロファイルへの移行、旧バージョンのローカルストレージ形式からの移行）が
/// 実行済みかどうかを記録する汎用台帳。`migrationId`はアプリ側が決める
/// 任意の文字列キー。drift自体のスキーマ移行（`MigrationStrategy`）とは別物で、
/// アプリ側のコード（Dartロジック）で行う一度きりの処理を対象とする。
abstract class MigrationLedger {
  Future<bool> isApplied(String migrationId);

  Future<void> markApplied(String migrationId);

  /// 保護者からのデータ削除要求（LGPD/ECA Digital対応）に応じて全件消去する。
  Future<void> clearAll();
}
