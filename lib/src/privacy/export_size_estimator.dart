import 'dart:convert';

/// `exportUserData`等が返すデータをJSON化した際のおおよそのバイト数を
/// 見積もり、分割（`ExportChunker`）が必要かを判定する純関数。
/// `ExportChunker`自体は件数ベースで分割するのみでバイト数は見ないため、
/// 本クラスは実際にJSON文字列化してバイト数を測り、サイズベースで判定を
/// 補う。実際の分割保存・結合処理はアプリ側（`ExportChunker`）の責務とする。
class ExportSizeEstimator {
  const ExportSizeEstimator({this.maxBytes = 1024 * 1024});

  /// これを超えるバイト数であれば分割が必要と判定する。
  final int maxBytes;

  /// [items]をJSON文字列化した際のUTF-8バイト数を返す。
  int estimateBytes(List<Map<String, dynamic>> items) {
    return utf8.encode(jsonEncode(items)).length;
  }

  /// [items]のバイト数が[maxBytes]を超えていれば分割が必要と判定する。
  bool needsChunking(List<Map<String, dynamic>> items) {
    return estimateBytes(items) > maxBytes;
  }
}
