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
- `example/`に週次レポート画面を追加し、弱点ノート（`WeakNotesAnalyzer`）・
  週次レポート（`WeeklyReportBuilder`）のUI結合確認を行えるようにした。
  `QuestionSource`は生成した問題を保持しないため、サンプルアプリ側で
  `QuestionCache`（questionId→Questionの簡易ルックアップ）を追加している。
- BNCCカリキュラムの第2回検証パスとして、複数の独立した教育系サイトで
  内容が一致した`mat_numeros_4`/`mat_numeros_5`/`mat_algebra_2`を
  `verified: true`に更新（unverified 16→13単元、詳細はADR参照）。
- LGPD第14条・ECA Digital（Lei 15.211/2025）の法令確認状況をADRに整理。
  `regional/pt_BR.yaml`の既定値はLGPD第14条とは整合する一方、ECA Digitalの
  アプリダウンロード同意要件の対象年齢が未確定であることを明記（コード変更なし、
  弁護士確認待ちの事項として記録）。
- `example/`にgrowth（`DailyMissionRules`/`CoinWallet`/`GrowthStageCalculator`）の
  UI結合確認を追加。`GrowthRepository`（端末内の簡易な状態保持）を介して、
  正解のたびにミッション進捗・コイン・成長段階が更新される様子を
  出題画面・ホーム画面の両方に表示する。
- `example/`にEntitlement（課金状態）連動の単元ロックUIを追加。premiumトグルで
  購入フローを模擬し、`Entitlement.isUnlocked`に応じて単元タップ時の
  ロックメッセージ表示/出題画面遷移を切り替える結合確認を追加した。
- `InMemoryProgressStore`をコアに追加し、`DriftProgressStore`と共通の
  契約テストスイート（`test/progress_store_contract_test.dart`）で
  両実装の整合性を検証できるようにした。
- `ArithmeticQuestionSource`の減算に典型的な誤解タグ（`subtraction_as_addition`）
  を追加し、`WeakNotesAnalyzer.isOvercome()`の判定結果を`example/`の出題画面に
  「誤解を克服しました」バッジとして表示する結合確認を追加した。
- `example/`にScreenTimeGuardのUI結合確認を追加。出題画面の滞在時間を積算し、
  制限模擬トグルで残り時間表示・超過時のロックメッセージを確認できるようにした。
- `example/`にAgeGate/ConsentStoreのUI結合確認を追加。生まれ年入力→
  保護者同意要否判定→（必要なら）同意ダイアログ→`ConsentStore`記録、という
  一連のフローと同意状態表示タイルを追加した。
- `example/`にNotificationScheduler/DailyReminderPlannerのUI結合確認を追加。
  ホーム画面にデイリーミッションのリマインド通知タイルを追加し、タップで
  `InMemoryNotificationScheduler`への通知予約/解除を切り替えられるようにした。
- `example/`にデータ書き出し/削除・同意撤回のUI結合確認を追加。保護者向けの
  `DataPrivacyScreen`を追加し、同意状態・書き出し対象の学習記録件数の確認、
  保護者同意の撤回、確認ダイアログを経た全データ削除を行えるようにした。
- ADRに「教科別アプリ/レポジトリ分割と本コアの境界」の設計メモを追加。
  算数固有のカリキュラムJSON・QuestionSource実装群は将来独立レポジトリへ
  移設する対象であることを明記し、今後本コアに他教科の教科固有コードを
  追加しない方針を整理した。
- growthモジュールに`GrowthStore`抽象（`InMemoryGrowthStore`/`DriftGrowthStore`）
  を追加し、`ProgressStore`/`ConsentStore`と同様に永続化先を差し替え可能にした。
  `example/`の`GrowthRepository`を`GrowthStore`への保存・復元に書き換えた。
- `exportUserData`の結果をJSON文字列化する`exportUserDataAsJson`を追加した。
  `example/`の`DataPrivacyScreen`に書き出し内容をクリップボードへコピーする
  ボタンを追加し、UI結合確認を行った。
- 米国(en, COPPA)向けの`regional/en.yaml`を新規ロケール追加の雛形として追加。
  ADRに「新規ロケール追加の手順」を整理し、本コアに追加すべきもの（RegionalProfile・
  l10n）と算数アプリ側に残すべきもの（カリキュラムJSON）を区別した。
