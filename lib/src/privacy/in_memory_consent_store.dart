import '../models/models.dart';
import 'consent_store.dart';

/// テスト・プロトタイプ用の `ConsentStore` 実装。実運用では端末内永続化実装に置き換える。
class InMemoryConsentStore implements ConsentStore {
  ConsentRecord? _record;

  @override
  Future<ConsentRecord?> getConsent() async => _record;

  @override
  Future<void> setConsent(ConsentRecord record) async => _record = record;

  @override
  Future<void> revokeConsent() async => _record = null;

  @override
  Future<void> eraseAll() async => _record = null;
}
