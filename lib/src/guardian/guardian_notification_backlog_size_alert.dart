/// `GuardianNotificationDigestThrottle`によってまとめ送り抑制された保護者
/// 向け通知が、一定件数以上積み上がっている状態を検知する純関数。
/// `GuardianNotificationDigestThrottle`は1回の送信を抑制すべきかの単発
/// 判定のみを行い、抑制された通知が積み上がっているかは見ない。実際の
/// まとめ送り処理の実行判断はアプリ側の責務とする。
class GuardianNotificationBacklogSizeAlert {
  const GuardianNotificationBacklogSizeAlert({this.backlogThreshold = 5});

  /// 抑制済みの通知件数がこの数以上になったら積み上がりとみなす。
  final int backlogThreshold;

  /// [throttledNotificationCount]（まとめ送り抑制によって保留されている
  /// 通知の件数）が[backlogThreshold]以上であれば、積み上がり状態と
  /// 判定する。
  bool isBacklogged(int throttledNotificationCount) {
    return throttledNotificationCount >= backlogThreshold;
  }
}
