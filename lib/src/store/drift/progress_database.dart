import 'package:drift/drift.dart';

part 'progress_database.g.dart';

@DataClassName('AttemptRow')
class Attempts extends Table {
  TextColumn get questionId => text()();
  TextColumn get unitId => text()();
  BoolColumn get correct => boolean()();
  TextColumn get chosenId => text().nullable()();
  DateTimeColumn get answeredAt => dateTime()();
  IntColumn get elapsedMs => integer().withDefault(const Constant(0))();
  TextColumn get mode => text().withDefault(const Constant('practice'))();

  @override
  Set<Column> get primaryKey => {questionId, answeredAt};
}

/// 保護者同意の記録。LGPD第14条「特定かつ目立つ形の同意」の記録として、
/// 単一行(id固定)で最新の同意状態のみを保持する。
@DataClassName('ConsentRow')
class Consents extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  BoolColumn get parentalConsentGiven => boolean()();
  DateTimeColumn get consentedAt => dateTime().nullable()();
  IntColumn get policyVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Attempts, Consents])
class ProgressDatabase extends _$ProgressDatabase {
  ProgressDatabase(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(consents);
          }
        },
      );
}
