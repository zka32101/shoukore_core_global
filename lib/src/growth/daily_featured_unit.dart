/// 「毎日使いたくなる仕掛け」として、日付ごとに決定的に1つの単元(または
/// 任意のID)を「今日の挑戦」として選ぶ純関数。同じ日なら誰が開いても
/// 同じIDが選ばれ、日が変われば違うIDになる(サーバー同期不要・端末時刻
/// のみで完結する簡易な日替わりコンテンツ)。[eligibleUnitIds]の中身・
/// 並び順はアプリ側の責務（教科・単元の概念はコア側では扱わない）。
String? dailyFeaturedUnitId(DateTime date, List<String> eligibleUnitIds) {
  if (eligibleUnitIds.isEmpty) return null;
  final dayOfYear = int.parse(
    '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}',
  );
  final index = dayOfYear % eligibleUnitIds.length;
  return eligibleUnitIds[index];
}
