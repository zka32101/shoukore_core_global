/// 効果音/BGMのミュート設定が長期間解除されずに続いている場合、再度音を
/// 有効にしてよいか確認を提案すべきかを判定する純関数。
/// `AudioCueVolumeDuckingSuggestion`（再生中の一時的な音量調整）とは異なり、
/// 本クラスはミュート状態自体がいつから続いているかのみを見る。実際の
/// ミュート解除確認ダイアログの表示はアプリ側の責務とする。
class AudioMuteStalenessNotice {
  const AudioMuteStalenessNotice({this.stalenessPeriod = const Duration(days: 14)});

  /// ミュートを開始してからこの期間を超えていれば、解除確認を提案すべきと
  /// 判定する。
  final Duration stalenessPeriod;

  /// [isMuted]が`false`であれば提案不要。`true`の場合、[mutedSince]からの
  /// 経過時間が[stalenessPeriod]を超えていれば解除確認を提案すべきと判定
  /// する。
  bool shouldSuggestUnmuteConfirmation({
    required bool isMuted,
    required DateTime mutedSince,
    required DateTime now,
  }) {
    if (!isMuted) return false;
    return now.difference(mutedSince) > stalenessPeriod;
  }
}
