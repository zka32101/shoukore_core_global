import 'guardian_gate_lockout.dart';

/// `GuardianGateLockout`によるロックが解除間近であることを事前に知らせる
/// べきかを判定する純関数。`GuardianGateLockout`自体はロック中かどうかの
/// 二値判定のみを行い、解除までの残り時間が近いことの事前通知は見ない
/// ため、本クラスが独立してその判定を行う。実際の「もうすぐ解除されます」
/// 表示はアプリ側の責務とする。
class GuardianGateLockoutEndingSoonNotice {
  const GuardianGateLockoutEndingSoonNotice({this.remainingTimeThreshold = const Duration(seconds: 30)});

  /// ロック解除までこの時間を切ったら「もうすぐ解除」とみなす。
  final Duration remainingTimeThreshold;

  /// [state]がロック中であり、[now]から[GuardianGateLockoutState.lockedUntil]
  /// までの残り時間が[remainingTimeThreshold]以下であれば、解除間近と
  /// 判定する。ロック中でない場合は`false`を返す。
  bool isEndingSoon({required GuardianGateLockoutState state, required DateTime now}) {
    final lockedUntil = state.lockedUntil;
    if (lockedUntil == null || !now.isBefore(lockedUntil)) return false;
    return lockedUntil.difference(now) <= remainingTimeThreshold;
  }
}
