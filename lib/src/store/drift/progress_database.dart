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

/// growth状態（コイン残高・デイリーミッション進捗・累計正答数）。単一行(id固定)で
/// 最新状態のみを保持する（`DailyMissionState`/`CoinWallet`は純関数のため履歴は持たない）。
@DataClassName('GrowthStateRow')
class GrowthStates extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  IntColumn get totalCorrectAnswers => integer().withDefault(const Constant(0))();
  IntColumn get coinBalance => integer().withDefault(const Constant(0))();
  DateTimeColumn get missionDay => dateTime().nullable()();
  IntColumn get missionCompletedCount => integer().withDefault(const Constant(0))();
  BoolColumn get missionRewardClaimed => boolean().withDefault(const Constant(false))();
  IntColumn get currentStreakDays => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastStudiedDay => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 利用時間計測（ECA Digitalの保護者監督ツール対応）。単一行(id固定)で
/// 「今日」の利用時間のみを保持する（日次リセットは`DailyBoundary`に委ねる）。
@DataClassName('ScreenTimeStateRow')
class ScreenTimeStates extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  IntColumn get usedTodayMinutes => integer().withDefault(const Constant(0))();
  DateTimeColumn get day => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 複数の子どもプロファイル（1台の端末を複数の子どもで共有する想定）。
@DataClassName('ProfileRow')
class Profiles extends Table {
  TextColumn get id => text()();
  TextColumn get displayName => text()();
  IntColumn get birthYear => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 現在選択中のプロファイルID。単一行(id固定)で保持する。
@DataClassName('ActiveProfileRow')
class ActiveProfileState extends Table {
  IntColumn get id => integer().withDefault(const Constant(0))();
  TextColumn get activeProfileId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 所持アイテム（コインで購入したアバター装飾等）。1行=1所持アイテム。
@DataClassName('OwnedItemRow')
class OwnedItems extends Table {
  TextColumn get itemId => text()();

  @override
  Set<Column> get primaryKey => {itemId};
}

/// サーバー同期の送信待ちアイテム。`payload`はアプリ側が決める任意のJSONを
/// 文字列化して保持する（本コアはキューの管理のみを担い、内容を解釈しない）。
@DataClassName('PendingSyncItemRow')
class PendingSyncItems extends Table {
  TextColumn get id => text()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// `MigrationLedger`が管理する、アプリ側の一度きりの移行処理の実行済み記録。
/// 1行=1`migrationId`。
@DataClassName('AppliedMigrationRow')
class AppliedMigrations extends Table {
  TextColumn get migrationId => text()();

  @override
  Set<Column> get primaryKey => {migrationId};
}

@DriftDatabase(
  tables: [
    Attempts,
    Consents,
    GrowthStates,
    ScreenTimeStates,
    Profiles,
    ActiveProfileState,
    OwnedItems,
    PendingSyncItems,
    AppliedMigrations,
  ],
)
class ProgressDatabase extends _$ProgressDatabase {
  ProgressDatabase(super.e);

  @override
  int get schemaVersion => 9;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(consents);
          }
          if (from < 3) {
            await m.createTable(growthStates);
          }
          if (from < 4) {
            await m.addColumn(growthStates, growthStates.currentStreakDays);
            await m.addColumn(growthStates, growthStates.lastStudiedDay);
          }
          if (from < 5) {
            await m.createTable(screenTimeStates);
          }
          if (from < 6) {
            await m.createTable(profiles);
            await m.createTable(activeProfileState);
          }
          if (from < 7) {
            await m.createTable(ownedItems);
          }
          if (from < 8) {
            await m.createTable(pendingSyncItems);
          }
          if (from < 9) {
            await m.createTable(appliedMigrations);
          }
        },
      );
}
