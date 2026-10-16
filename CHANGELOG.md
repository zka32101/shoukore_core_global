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
- `ReviewSessionPacer`（学習セッション内の休憩提案タイミング判定）を追加（guardian）。
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
- `Question.explanationId`を実際に有効化した。四則演算の各テンプレに
  `explanationId`を設定し、`example/`で回答後に教科書的な解説を表示する
  UI結合確認を追加した。
- growthモジュールに学習ストリーク（何日連続で学習したか）を計算する
  `LearningStreak`を追加。`GrowthSnapshot`/`GrowthStore`に状態を持たせ、
  `example/`の出題画面で正誤を問わず全回答時に更新・表示するようにした。
- `ScreenTimeStore`抽象（`InMemoryScreenTimeStore`/`DriftScreenTimeStore`）を
  追加し、`ProgressStore`/`GrowthStore`と同様に利用時間の永続化先を差し替え
  可能にした。`example/`に`ScreenTimeRepository`を追加し、端末内メモリの
  積算（再起動で消え日次リセットもされないバグがあった）から移行した。
- `weak`モジュールに誤答問題の間隔反復(spaced repetition)復習タイミングを計算する
  `SpacedReviewScheduler`を追加した（Leitner方式、箱レベル0〜4）。
- growthモジュールに`GrowthSnapshot`から達成済みバッジを判定する
  `AchievementEvaluator`を追加した（ストリーク3/7/30日、累計正答数100/500問）。
- 1台の端末を複数の子どもで共有する家庭向けに、`ProfileStore`抽象
  （`InMemoryProfileStore`/`DriftProfileStore`）を追加した。プロファイルの
  一覧・選択状態の管理のみを提供し、`Progress`/`Growth`/`ScreenTime`等の
  既存ストアをプロファイルごとに分離する実装はアプリ側の責務とする。
- コインで購入できるアイテムの所持状態を管理する`InventoryStore`抽象
  （`InMemoryInventoryStore`/`DriftInventoryStore`）と、購入判定・状態遷移を
  行う純関数`InventoryManager`をgrowthモジュールに追加した。アイテムの
  絵柄・価格等の表示情報はアプリ側データとし、本コアは`StoreItem`
  （id/priceCoinsのみ）と所持判定のロジックを提供する。
- `WeeklyReportBuilder`の日次版として`DailyDigestBuilder`を追加した。
  `ProgressStore`から今日分の記録を集計し、`GrowthSnapshot.currentStreakDays`
  と合わせて保護者向け日次要約データ（`DailyDigest`）を組み立てる。通知文言・
  `NotificationScheduler`への実際のスケジューリングはアプリ側の責務とする。
- `RegionalProfile.locale`に基づく数値・日付・時刻のフォーマッタ`LocaleFormatter`
  （`package:intl`を利用）を追加した。保護者ゲート等でアプリ側が数字・日付表記を
  ベタ書きしないよう、本コアにユーティリティとして用意した。
- 将来のサーバー同期機能に備え、送信失敗した学習記録等を溜めて再送する
  `PendingSyncQueue`抽象（`InMemoryPendingSyncQueue`/`DriftPendingSyncQueue`）を
  syncモジュールに追加した。実際の送信（HTTP等）・APIはアプリ側の責務とし、
  本コアはキューの永続化・再送管理のみを提供する。
- `ProfileStore`のアクティブプロファイル切替時に他プロファイルの学習データを
  誤って混在させないための軽量ガード`ActiveProfileGuard`を追加した。
  （`isSameProfile`/`ensureSameProfile`）
- 端末移行時に保護者が引き継ぎたい設定（同意状態・プロファイル一覧・選択中
  プロファイル）をまとめてバックアップ/復元する`exportSettingsBackup`/
  `importSettingsBackup`（JSON文字列版含む）を追加した。学習記録は
  `exportUserData`が別途担うため対象外とする。
- フィードバック音声・効果音の再生要求を抽象化する`AudioCuePlayer`
  （`InMemoryAudioCuePlayer`）を追加した。`NotificationScheduler`と同様、
  実際の音声アセット・再生エンジンはアプリ側の責務とする。
- 保護者向けレポート（週次/日次）の既読状態を記録する`ReportReadState`抽象
  （`InMemoryReportReadState`/`DriftReportReadState`）を追加した。
  レポートの内容・文言には関与せず、`reportType`ごとの既読時刻のみを保持する。
- アプリ側の一度きりの移行処理（旧シングルプロファイルから複数プロファイルへの
  移行等）が実行済みかどうかを記録する`MigrationLedger`抽象
  （`InMemoryMigrationLedger`/`DriftMigrationLedger`）を追加した。drift自体の
  スキーマ移行（`MigrationStrategy`）とは別物である。
- `exportUserData`等が返すリストを件数ごとに分割する`ExportChunker`を追加した。
  学習記録が多い端末でも一度に全件をメモリへ展開せずに書き出せるようにする。
- `GuardianGate`の計算チャレンジに繰り返し失敗した際、一定時間ロックする
  純関数`GuardianGateLockout`を追加した。子どもが総当たりで保護者ゲートを
  突破するのを防ぐ。
- `tool/check_l10n_parity.dart`（`l10n/app_*.arb`間のキー整合性検証ツール、
  CI組み込み）を追加した。新規ロケール追加時のキー欠落・余剰を検出する。
- 保護者が設定した時間帯（就寝時間など）に新規ミッション開始や通知を控える
  べきかを判定する純関数`QuietHoursGuard`を`guardian`モジュールに追加した。
  `ScreenTimeGuard`（累積利用時間の制限）とは独立した、時刻帯ベースの制限。
- OS側の端末ロケールから、本コアが対応済みのロケールへの近似マッチを提案する
  純関数`DeviceLocaleSuggester`を`regional`モジュールに追加した。初回起動時の
  既定ロケール選定に使う。
- 保護者同意に有効期限・ポリシーバージョンを設け、再同意が必要かどうかを
  判定する純関数`ConsentExpiryPolicy`（`isExpired`/`needsReconfirmation`）を
  privacyモジュールに追加した。`ConsentStore`への保存・読込自体には関与しない。
- `example/`のUIをMaterial3テーマ・Card化・アイコン・配色で整理し、見やすさを
  改善した（コア本体の挙動・widgetテストが依存する文言・Keyは変更していない）。
- `PendingSyncQueue`の再送失敗回数から次回再送までの待機時間を指数バックオフで
  計算する純関数`RetryBackoffPolicy`をsyncモジュールに追加した。実際のHTTP送信・
  APIコールはアプリ側の責務とする。
- ローカルデータが最後にサーバーへ同期されてから一定期間を超えている場合に
  「要同期」と判定する純関数`StaleDataPolicy`をsyncモジュールに追加した。
  最終同期時刻の記録・保存自体はアプリ側の責務とする。
- `Mastery`一覧から未学習・弱点が強い単元を優先して次に学習すべき単元を
  提案する純関数`UnitRecommendation`（`recommend`/`topPick`）をquestion
  モジュールに追加した。
- 一定時間操作がない場合にロック状態へ戻すべきかを判定する純関数
  `SessionTimeoutPolicy`をguardianモジュールに追加した。共有端末での
  意図しない継続利用を防ぐ。`GuardianGate`とは独立した制限。
- 一定期間学習していない単元の`Mastery.score`を時間経過で緩やかに減衰させる
  純関数`MasteryDecay`をquestionモジュールに追加した。`ProgressStore`への
  保存は行わず、`UnitRecommendation`等への入力として使う表示・判定用の値を
  計算するだけ。
- `exportUserData`の出力を再取り込みする前に想定キー構成・型を検証する
  純関数`ExportIntegrityChecker`（`validate`/`isValid`）をprivacyモジュール
  に追加した。端末移行時のインポート処理の安全性を上げる。
- 短時間に何度もプロファイル切替が行われた場合に一定時間制限すべきかを
  判定する純関数`ProfileSwitchCooldown`をprofileモジュールに追加した。
  `ActiveProfileGuard`とは独立した、切替操作自体の頻度制限。
- 1日あたりのコイン消費量に上限を設け、`InventoryManager`での購入が超過
  しないかを判定する純関数`CoinSpendingLimit`をgrowthモジュールに追加した。
  日替わり判定・リセット自体はアプリ側（`DailyBoundary`併用）の責務とする。
- `QuietHoursGuard`の結果を踏まえ、静かな時間帯に予定されていた通知を
  時間帯明け直後に再スケジュールすべき時刻を計算する純関数
  `NotificationQuietMerge`をnotifyモジュールに追加した。
- 連続正解数に応じたボーナスコインを計算する純関数`AnswerStreakBonus`を
  growthモジュールに追加した。`CoinWallet.earn`への反映はアプリ側が行う。
- 同意の付与・撤回・ポリシー更新などのイベント履歴を追記・整理する純関数
  `ConsentAuditLog`（`ConsentAuditEntry`）をprivacyモジュールに追加した。
  `ConsentStore`（現在の同意状態のみ）とは別の履歴専用の仕組み。
- 端末のタイムゾーンが前回記録時と変わっていないかを検出する純関数
  `TimeZoneDriftDetector`をregionalモジュールに追加した。`DailyBoundary`
  の日付境界判定が乱れる手がかりに使う。
- 保護者向け共有カード表示用のメタデータを組み立てる純関数
  `AchievementShareCardBuilder`（`AchievementShareCardData`、`AchievementRank`）
  をgrowthモジュールに追加した。
- 進化段階の変化を手がかりにアバター変更を提案すべきかを判定する純関数
  `ProfileAvatarRotationSuggester`をprofileモジュールに追加した。
- 弱点単元の誤解頻出度に応じた復習タイミングを計算する純関数
  `WeakNotesReviewScheduler`をweakモジュールに追加した。
- 保護者向けダイジェスト通知の一時ミュート期間を判定する純関数
  `GuardianDigestMuteWindow`をguardianモジュールに追加した。
- サブスクリプション失効後の猶予期間を判定する純関数
  `EntitlementGracePeriod`をentitlementモジュールに追加した。
- 保護者の非同期承認フローを扱う純関数`GuardianApprovalRequestQueue`
  （`GuardianApprovalRequest`）をguardianモジュールに追加した。
- 単元ごとのマスターバッジ付与条件を判定する純関数
  `UnitMasteryBadgeEligibility`をgrowthモジュールに追加した。
- オフライン同期時の競合を解決する純関数`OfflineSyncConflictResolver`
  （`SyncableRecord`、last-write-wins）をsyncモジュールに追加した。
- 1日あたりのコイン獲得量に上限を設ける純関数`CoinEarningCapPerDay`
  （`CoinEarningState`）をgrowthモジュールに追加した。
- プロフィール写真利用の追加同意を判定する純関数`ProfilePhotoConsentGate`
  （`ProfilePhotoConsent`）をprivacyモジュールに追加した。
- ストリークの見逃し猶予を判定する純関数`StreakRecoveryGrace`を
  growthモジュールに追加した。
- 適応難易度の急激な変動を検知する純関数`QuestionDifficultyDriftAlert`を
  adaptiveモジュールに追加した。
