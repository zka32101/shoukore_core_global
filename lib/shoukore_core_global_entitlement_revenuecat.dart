/// RevenueCatを使った`EntitlementReader`の実装。別入口に分離し、コア本体
/// （`shoukore_core_global.dart`）はRevenueCat SDKに依存しない。
library;

export 'src/entitlement/revenue_cat_entitlement_mapper.dart';
export 'src/entitlement/revenue_cat_entitlement_reader.dart';
