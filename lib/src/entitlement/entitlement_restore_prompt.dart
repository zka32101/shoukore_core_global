import '../models/models.dart';

/// 以前は購入済み（プレミアムまたは教科アンロック）だったはずなのに、
/// 現在の`EntitlementReader`の結果がそれを反映していない場合、購入の
/// 復元（リストア）を促すべきかを判定する純関数。`EntitlementGracePeriod`
/// （失効直後の継続利用猶予）とは異なり、再インストール等で権利情報が
/// 同期されていない状態を検知する。実際のリストア処理・UI表示はアプリ側の
/// 責務とする。
class EntitlementRestorePrompt {
  const EntitlementRestorePrompt();

  /// [previouslyUnlockedSubjectIds]（ローカルに記録済みの以前アンロック
  /// していた教科ID）のうち、[current]（現在の権利情報）で未アンロック
  /// のものが1件以上あれば、復元を促すべきと判定する。
  bool shouldPromptRestore({
    required Set<String> previouslyUnlockedSubjectIds,
    required Entitlement current,
  }) {
    if (previouslyUnlockedSubjectIds.isEmpty) return false;
    return previouslyUnlockedSubjectIds.any((id) => !current.isUnlocked(id));
  }
}
