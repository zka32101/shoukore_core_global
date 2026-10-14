import '../progress/progress_store.dart';
import 'consent_store.dart';

/// LGPD上の権利行使（データ削除要求）に対応する。同意記録・学習記録を
/// まとめて端末内から消去する。
Future<void> eraseAllUserData({
  required ConsentStore consentStore,
  required ProgressStore progressStore,
}) async {
  await consentStore.eraseAll();
  await progressStore.clearAll();
}
