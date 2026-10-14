/// コインで購入できるアイテム（アバター装飾等）の定義。絵柄・説明文等の
/// 表示情報はアプリ側のデータ・l10nが持つため、本コアは価格判定に必要な
/// 情報のみを保持する。
class StoreItem {
  const StoreItem({required this.id, required this.priceCoins}) : assert(priceCoins >= 0);

  final String id;
  final int priceCoins;
}
