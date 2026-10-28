import 'package:purchases_flutter/purchases_flutter.dart';

import '../models/models.dart';
import 'entitlement_reader.dart';
import 'revenue_cat_entitlement_mapper.dart';

/// RevenueCatを使った`EntitlementReader`の実装。
///
/// `Purchases.configure`（APIキー設定）はアプリ起動時にアプリ側が行う前提。
/// 価格・商品・無料期間ロジックには関与せず、RevenueCatの`CustomerInfo`を
/// 読み取って`Entitlement`に変換するのみ。購入・復元の実行結果も同じ変換で
/// `Entitlement`を返す。
class RevenueCatEntitlementReader implements EntitlementReader {
  RevenueCatEntitlementReader({
    required this.subjectEntitlementIds,
    this.premiumEntitlementId,
  });

  /// 教科ID(subjectId) → RevenueCatダッシュボードのentitlement識別子。
  final Map<String, String> subjectEntitlementIds;

  /// premium判定に使うentitlement識別子（単一のpremium entitlementを
  /// 使わないアプリではnullのままでよい）。
  final String? premiumEntitlementId;

  Entitlement _fromCustomerInfo(CustomerInfo info) => entitlementFromCustomerInfo(
        info,
        subjectEntitlementIds: subjectEntitlementIds,
        premiumEntitlementId: premiumEntitlementId,
      );

  @override
  Future<Entitlement> current() async {
    final info = await Purchases.getCustomerInfo();
    return _fromCustomerInfo(info);
  }

  /// 指定のパッケージを購入し、更新後の`Entitlement`を返す。
  Future<Entitlement> purchasePackage(Package package) async {
    final result = await Purchases.purchase(PurchaseParams.package(package));
    return _fromCustomerInfo(result.customerInfo);
  }

  /// 購入復元を実行し、更新後の`Entitlement`を返す。
  Future<Entitlement> restorePurchases() async {
    final info = await Purchases.restorePurchases();
    return _fromCustomerInfo(info);
  }
}
