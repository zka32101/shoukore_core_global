# shoukore_core_global

小学コレ！海外版（ブラジル pt-BR 先行）向けの多言語対応共通コア。

方針（1行）: 「言語・地域は"データ"、コードは中立」。ロケール差分は
①文言(arb) ②カリキュラム木(JSON) ③地域コンプラ設定(profile) の3つに閉じ込める。
既存 `shared_core` / 日本語アプリには手を入れない。

設計の背景・対策表・モジュール構成は `docs/decisions/0001-design-overview.md` を参照。

## モジュール

| モジュール | 役割 |
|---|---|
| question | 問題モデル・出題・採点（`QuestionSource`抽象） |
| progress | 学習記録（`ProgressStore`、既定: drift/SQLite、端末内） |
| adaptive | 適応難易度（純関数＋`Clock`） |
| guardian | 保護者ゲート・利用時間制限 |
| growth | デイリーミッション・キャラ・コイン |
| privacy | 同意管理・データ削除/書き出し（`ConsentStore`） |
| notify | ローカル通知（`NotificationScheduler`） |

抽象IF: `QuestionSource` / `ProgressStore` / `Clock` / `NotificationScheduler` / `ConsentStore` / `EntitlementReader`

## 技術ルール

- Flutter/Dart、状態管理Riverpod、ローカルDB drift。Firebase依存ゼロ。freezed不使用（素のimmutableクラス）。
- 文字列は全て `l10n/app_*.arb` 経由。`Text()` への直書きは `dart run tool/check_l10n.dart` でCI失敗させる。
- 教科/単元はカリキュラムJSON（`curriculum/{locale}.json`）のID。
- アプリからは `ref: vX.Y.Z` で参照。SemVer。破壊的変更は `docs/decisions/` にADRを追加する。

## エントリポイント

- `shoukore_core_global.dart`: コア本体（Flutterプラグイン依存なし）
- `shoukore_core_global_drift.dart`: drift(SQLite)実装（`DriftProgressStore`/`DriftConsentStore`）
- `shoukore_core_global_notify.dart`: `flutter_local_notifications`実装（`LocalNotificationScheduler`）

## 開発

```
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
dart run tool/check_l10n.dart
dart run tool/check_curriculum.dart
flutter test
```

## サンプルアプリ（結合確認）

`example/` に ja/pt_BR 両ロケールでの単元一覧→出題→採点→progress記録→
保護者ゲートの結合を確認する最小アプリがある。コアが同梱する
`curriculum/`・`regional/`・`l10n/` をパッケージアセット経由でそのまま読み込む。

```
cd example
flutter pub get
flutter analyze
flutter test
```
