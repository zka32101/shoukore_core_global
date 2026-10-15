import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const chunker = ExportChunker();

  group('ExportChunker', () {
    test('chunkByCountは指定件数ごとに分割する', () {
      final items = List.generate(5, (i) => {'id': i});
      final chunks = chunker.chunkByCount(items, maxItemsPerChunk: 2);

      expect(chunks.length, 3);
      expect(chunks[0], [{'id': 0}, {'id': 1}]);
      expect(chunks[1], [{'id': 2}, {'id': 3}]);
      expect(chunks[2], [{'id': 4}]);
    });

    test('空リストは1件の空チャンクを返す', () {
      final chunks = chunker.chunkByCount([], maxItemsPerChunk: 2);
      expect(chunks, [[]]);
    });

    test('maxItemsPerChunkが0以下なら例外', () {
      expect(() => chunker.chunkByCount([], maxItemsPerChunk: 0), throwsArgumentError);
    });

    test('chunkToJsonはchunkIndex/chunkCount付きのJSON文字列を返す', () {
      final items = List.generate(3, (i) => {'id': i});
      final jsonChunks = chunker.chunkToJson(items, maxItemsPerChunk: 2);

      expect(jsonChunks, hasLength(2));
      final first = jsonDecode(jsonChunks[0]) as Map<String, dynamic>;
      expect(first['chunkIndex'], 0);
      expect(first['chunkCount'], 2);
      expect(first['items'], [{'id': 0}, {'id': 1}]);
    });
  });
}
