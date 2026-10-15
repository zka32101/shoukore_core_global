import 'report_read_state.dart';

/// `ReportReadState`の端末内メモリ実装。テスト・プロトタイピング用途、または
/// 永続化が不要な軽量アプリ向け。既定実装は`DriftReportReadState`（端末内drift）で、
/// 本実装は同じ契約を満たす（`test/report_read_state_contract_test.dart`参照）。
class InMemoryReportReadState implements ReportReadState {
  final Map<String, DateTime> _lastReadAt = {};

  @override
  Future<DateTime?> getLastReadAt(String reportType) async => _lastReadAt[reportType];

  @override
  Future<void> markRead(String reportType, DateTime at) async {
    _lastReadAt[reportType] = at;
  }

  @override
  Future<void> clearAll() async {
    _lastReadAt.clear();
  }
}
