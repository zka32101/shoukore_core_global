import 'screen_time_snapshot.dart';

/// 利用時間計測（ECA Digitalの保護者監督ツール対応）の保存先を抽象化する。
/// `ScreenTimeGuard`自体は制限判定のみを行う純関数であり、計測値の永続化は
/// 本抽象（既定実装は端末内drift）に委ねる。
abstract class ScreenTimeStore {
  Future<ScreenTimeSnapshot> load();

  Future<void> save(ScreenTimeSnapshot snapshot);

  /// 保護者からのデータ削除要求（LGPD/ECA Digital対応）に応じて計測値を消去する。
  Future<void> clearAll();
}
