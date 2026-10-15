import 'dart:convert';

/// `exportUserData`等が返すリスト（学習記録等）が多い場合に備え、
/// 1件のJSON文字列として一度にメモリへ展開せず、指定件数ごとに分割して
/// 出力するためのユーティリティ。実際のファイル分割保存・結合はアプリ側の責務。
class ExportChunker {
  const ExportChunker();

  /// [items]を[maxItemsPerChunk]件ごとに分割する。
  List<List<Map<String, dynamic>>> chunkByCount(
    List<Map<String, dynamic>> items, {
    int maxItemsPerChunk = 500,
  }) {
    if (maxItemsPerChunk <= 0) {
      throw ArgumentError.value(maxItemsPerChunk, 'maxItemsPerChunk', 'must be positive');
    }
    final chunks = <List<Map<String, dynamic>>>[];
    for (var i = 0; i < items.length; i += maxItemsPerChunk) {
      chunks.add(items.sublist(i, (i + maxItemsPerChunk).clamp(0, items.length)));
    }
    return chunks.isEmpty ? [[]] : chunks;
  }

  /// [items]を分割し、各チャンクを`{chunkIndex, chunkCount, items}`の形で
  /// JSON文字列化したリストを返す。
  List<String> chunkToJson(
    List<Map<String, dynamic>> items, {
    int maxItemsPerChunk = 500,
  }) {
    final chunks = chunkByCount(items, maxItemsPerChunk: maxItemsPerChunk);
    return [
      for (var i = 0; i < chunks.length; i++)
        jsonEncode({
          'chunkIndex': i,
          'chunkCount': chunks.length,
          'items': chunks[i],
        }),
    ];
  }
}
