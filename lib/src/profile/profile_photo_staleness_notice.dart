/// プロフィール写真が登録・最終更新から長期間変わっていないことに
/// 気づけるようにすべきかを判定する純関数。`ProfileAvatarRotationSuggester`
/// （成長段階の進化イベントをきっかけに変更を促す）とは異なり、本クラス
/// は単純に経過時間のみを見る。実際の更新案内UIの表示はアプリ側の責務
/// とする。
class ProfilePhotoStalenessNotice {
  const ProfilePhotoStalenessNotice({this.stalenessPeriod = const Duration(days: 365)});

  /// 最終更新からこの期間を超えたら更新を促す。
  final Duration stalenessPeriod;

  /// [lastUpdatedAt]（写真の最終更新時刻、未設定の場合は`null`）から
  /// [now]までの経過が[stalenessPeriod]を超えていれば更新を促すべきと
  /// 判定する。写真自体が未設定（[lastUpdatedAt]が`null`）の場合は
  /// 対象外とする（初期状態の催促は別の仕組みに委ねる）。
  bool shouldNotify({required DateTime? lastUpdatedAt, required DateTime now}) {
    if (lastUpdatedAt == null) return false;
    return now.difference(lastUpdatedAt) > stalenessPeriod;
  }
}
