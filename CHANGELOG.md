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
- `DriftConsentStore`（`ConsentStore`の端末内drift実装、`ProgressDatabase`に`Consents`テーブルを追加）を追加。
- `exportUserData` / `eraseAllUserData`（LGPD上のデータ書き出し/削除の権利行使対応）を追加。
- `WeakNotesAnalyzer`（誤答のmisconceptionTagsから弱点傾向を集計、克服判定）を追加。
- `WeeklyReportBuilder`（保護者向け週次レポート）を追加。
- `tool/check_curriculum.dart`（カリキュラムJSONの整合性検証、CI組み込み）を追加。
- `GeometryQuestionSource`/`MeasurementQuestionSource`/`SequenceQuestionSource`/`StatisticsQuestionSource`
  （BNCC Geometria/Grandezas e medidas/Álgebra/Probabilidade e estatística向け）を追加。
  `Question`に`params`（問題文プレースホルダ用の値）を追加し、`CurriculumLoader`が
  複数テンプレ種別(`kind`)を判定できるよう拡張。
- `LocalNotificationScheduler`（`flutter_local_notifications`を使った`NotificationScheduler`の
  端末内実装、`shoukore_core_global_notify.dart`に分離）を追加。
- `curriculum/pt_BR.json`をBNCC 1º-5º ano × 5 eixo全25単元に本格拡充。
  `Unit`に`habilidadeCodes`/`verified`を追加し、一次資料で確認できた単元と
  要検証（現地教員レビュー前提）の単元を区別できるようにした（ADR参照）。
- BNCCカリキュラムの第2回検証パスとして、複数の独立した教育系サイトで
  内容が一致した`mat_numeros_4`/`mat_numeros_5`/`mat_algebra_2`を
  `verified: true`に更新（unverified 16→13単元、詳細はADR参照）。
