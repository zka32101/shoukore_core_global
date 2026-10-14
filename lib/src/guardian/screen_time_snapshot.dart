/// `ScreenTimeStore`が読み書きする永続化スナップショット。
/// `ScreenTimeGuard`への入力となる「今日の利用時間」を保持する。
class ScreenTimeSnapshot {
  const ScreenTimeSnapshot({this.usedTodayMinutes = 0, this.day});

  /// 未保存・初回起動時の既定状態。
  static const initial = ScreenTimeSnapshot();

  final int usedTodayMinutes;

  /// `usedTodayMinutes`が属するミッション日。`null`なら未計測。
  final DateTime? day;
}
