import 'package:drift/drift.dart';

import '../../models/models.dart';
import '../../privacy/consent_store.dart';
import 'progress_database.dart';

/// `ConsentStore` の既定実装。端末内drift(SQLite)に保存する。
/// 単一行(id=0)で最新の同意状態のみを保持する。
class DriftConsentStore implements ConsentStore {
  DriftConsentStore(this._db);

  static const _rowId = 0;

  final ProgressDatabase _db;

  @override
  Future<ConsentRecord?> getConsent() async {
    final row = await (_db.select(_db.consents)
          ..where((t) => t.id.equals(_rowId)))
        .getSingleOrNull();
    if (row == null) return null;
    return ConsentRecord(
      parentalConsentGiven: row.parentalConsentGiven,
      consentedAt: row.consentedAt,
      policyVersion: row.policyVersion,
    );
  }

  @override
  Future<void> setConsent(ConsentRecord record) async {
    await _db.into(_db.consents).insertOnConflictUpdate(
          ConsentsCompanion.insert(
            id: const Value(_rowId),
            parentalConsentGiven: record.parentalConsentGiven,
            consentedAt: Value(record.consentedAt),
            policyVersion: Value(record.policyVersion),
          ),
        );
  }

  @override
  Future<void> revokeConsent() async {
    await (_db.delete(_db.consents)..where((t) => t.id.equals(_rowId))).go();
  }

  @override
  Future<void> eraseAll() async {
    await _db.delete(_db.consents).go();
  }
}
