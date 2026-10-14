import 'profile.dart';

/// 複数の子どもプロファイル（1台の端末を複数の子どもで共有する想定）を
/// 管理する永続化先を抽象化する。`Progress`/`Growth`/`ScreenTime`等の
/// 既存ストアをプロファイルIDごとに分離する実装はアプリ側の責務とし、
/// 本コアはプロファイルの一覧・選択状態の管理のみを提供する。
abstract class ProfileStore {
  Future<List<Profile>> listProfiles();

  /// 新規追加・既存プロファイルの更新（同じidなら上書き）。
  Future<void> saveProfile(Profile profile);

  Future<void> removeProfile(String id);

  /// 現在選択中のプロファイルID。未選択（プロファイル未作成含む）なら`null`。
  Future<String?> getActiveProfileId();

  Future<void> setActiveProfileId(String? id);

  /// 保護者からのデータ削除要求（LGPD/ECA Digital対応）に応じて全プロファイルを消去する。
  Future<void> clearAll();
}
