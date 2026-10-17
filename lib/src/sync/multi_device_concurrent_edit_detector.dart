/// 同一プロファイルのデータが短時間に複数デバイスから更新され、進捗データが
/// 競合している可能性に気づけるようにする純関数。`OfflineSyncConflictResolver`
/// （競合が起きた後にどちらの値を採用するかの決定）とは異なり、本クラスは
/// 「競合が起きている／起きつつある」こと自体の検知のみを行う。実際の
/// 競合解決・保護者への通知はアプリ側の責務とする。
class MultiDeviceConcurrentEditDetector {
  const MultiDeviceConcurrentEditDetector({this.concurrencyWindow = const Duration(minutes: 5)});

  /// この時間差以内に異なるデバイスからの更新があれば、同時編集とみなす。
  final Duration concurrencyWindow;

  /// [firstUpdatedAt]/[firstDeviceId]と[secondUpdatedAt]/[secondDeviceId]が
  /// 異なるデバイスからの更新であり、その時刻差が[concurrencyWindow]以内で
  /// あれば、同時編集による競合の可能性があると判定する。
  bool isLikelyConcurrentEdit({
    required DateTime firstUpdatedAt,
    required String firstDeviceId,
    required DateTime secondUpdatedAt,
    required String secondDeviceId,
  }) {
    if (firstDeviceId == secondDeviceId) return false;
    final difference = firstUpdatedAt.difference(secondUpdatedAt).abs();
    return difference <= concurrencyWindow;
  }
}
