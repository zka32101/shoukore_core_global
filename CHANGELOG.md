# Changelog

## 0.1.0 (unreleased)

- リポジトリ雛形、CI、l10n lint を追加。
- `Clock` / `QuestionSource` / `ProgressStore` / `NotificationScheduler` / `ConsentStore` / `EntitlementReader` 抽象IFを定義。
- `ArithmeticQuestionSource`（四則演算問題生成）、`DriftProgressStore`（端末内drift実装）を追加。
- `AdaptiveDifficulty`（純関数＋Clockによる適応難易度）を追加。
- `GuardianGate`（保護者ゲート）、`ScreenTimeGuard`（利用時間制限）、`AgeGate`（年齢確認）、`InMemoryConsentStore` を追加。
- `l10n/app_{ja,pt_BR}.arb`、`curriculum/{ja,pt_BR}.json`、`regional/{ja,pt_BR}.yaml` 雛形を追加。
- `parseCurriculum` / `parseRegionalProfile` ローダーを追加。
- `DailyBoundary`（profile駆動の日付境界、固定5:00廃止）、`DailyMissionRules`、`CoinWallet`、`GrowthStageCalculator` を追加（growth）。
- `InMemoryNotificationScheduler`、`DailyReminderPlanner` を追加（notify）。
- `example/` にja/pt_BRサンプルアプリを追加し、単元一覧→出題→採点→progress記録→
  保護者ゲート→ロケール切替の結合をwidgetテストで確認（実装順⑧）。
- `l10n/app_pt.arb`（ベースロケール、gen-l10nの要件）を追加。
