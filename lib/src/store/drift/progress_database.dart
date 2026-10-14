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

@DriftDatabase(tables: [Attempts])
class ProgressDatabase extends _$ProgressDatabase {
  ProgressDatabase(super.e);

  @override
  int get schemaVersion => 1;
}
