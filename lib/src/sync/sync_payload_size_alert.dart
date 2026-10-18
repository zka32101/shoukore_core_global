import 'dart:convert';

import 'pending_sync_item.dart';

/// 同期キュー1件分の`PendingSyncItem.payload`のサイズが異常に大きい場合に
/// 気づけるようにする純関数。`ExportSizeEstimator`（データ書き出し全体の
/// サイズ推定、`ExportChunker`による分割の判定）とは異なり、本クラスは
/// 同期キューの個々のアイテムのサイズのみを見る。実際のペイロード圧縮・
/// 送信抑制はアプリ側の責務とする。
class SyncPayloadSizeAlert {
  const SyncPayloadSizeAlert({this.maxBytes = 64 * 1024});

  /// これを超えるバイト数であれば異常に大きいと判定する。
  final int maxBytes;

  /// [item]の`payload`をJSON文字列化した際のUTF-8バイト数を返す。
  int estimateBytes(PendingSyncItem item) {
    return utf8.encode(jsonEncode(item.payload)).length;
  }

  /// [item]のペイロードサイズが[maxBytes]を超えていれば異常に大きいと
  /// 判定する。
  bool isOversized(PendingSyncItem item) {
    return estimateBytes(item) > maxBytes;
  }
}
