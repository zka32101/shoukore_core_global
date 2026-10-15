import '../../guardian/report_read_state.dart';
import 'progress_database.dart';

/// `ReportReadState`の既定実装。端末内drift(SQLite)に保存する。
class DriftReportReadState implements ReportReadState {
  DriftReportReadState(this._db);

  final ProgressDatabase _db;

  @override
  Future<DateTime?> getLastReadAt(String reportType) async {
    final row = await (_db.select(_db.reportReadStates)
          ..where((t) => t.reportType.equals(reportType)))
        .getSingleOrNull();
    return row?.lastReadAt;
  }

  @override
  Future<void> markRead(String reportType, DateTime at) async {
    await _db.into(_db.reportReadStates).insertOnConflictUpdate(
          ReportReadStatesCompanion.insert(reportType: reportType, lastReadAt: at),
        );
  }

  @override
  Future<void> clearAll() async {
    await _db.delete(_db.reportReadStates).go();
  }
}
