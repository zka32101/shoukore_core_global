import '../models/models.dart';

/// 課金状態の読み取りを抽象化する。価格・無料期間ロジックはアプリ側(RevenueCat等)の責務。
/// コアは `Entitlement` を読むだけで、売り方や価格には関与しない。
abstract class EntitlementReader {
  Future<Entitlement> current();
}
