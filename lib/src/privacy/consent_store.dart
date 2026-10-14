import '../models/models.dart';

/// 保護者同意・年齢確認の記録を抽象化する。LGPD第14条・ECA Digital対応。
abstract class ConsentStore {
  Future<ConsentRecord?> getConsent();

  Future<void> setConsent(ConsentRecord record);

  Future<void> revokeConsent();

  /// データ削除・書き出し要求(LGPD上の権利行使)に対応する。
  Future<void> eraseAll();
}
