/// `LearningStreak`が途切れそうな日に「フリーズ券」を消費してストリークを
/// 保護すべきかを判定する純関数。`StreakRecoveryGrace`（学習自体による見逃し
/// 猶予）とは異なり、所持しているトークンの消費によって途切れを防ぐ経路を
/// 扱う。実際のトークン所持数の管理・付与・消費演出はアプリ側の責務とする。
class MissionStreakFreezeToken {
  const MissionStreakFreezeToken();

  /// [heldTokenCount]が1以上であれば、トークンを消費してストリークの
  /// 途切れを防ぐべきと判定する。
  bool shouldConsumeToken({required int heldTokenCount}) {
    return heldTokenCount > 0;
  }
}
