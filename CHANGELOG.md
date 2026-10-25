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
- 地域の祝日・休校日にデイリーミッションをスキップしてよいかを判定する
  純関数`RegionalHolidayMissionSkip`をgrowthモジュールに追加した。
- 無操作時にプロフィール切替を提案すべきかを判定する純関数
  `SiblingProfileSwitchSuggestion`をprofileモジュールに追加した。
- 適応難易度の急激な変動を検知する純関数`QuestionDifficultyDriftAlert`を
  adaptiveモジュールに追加した。
- `ScreenTimeGuard`の残り時間低下を事前に警告する純関数
  `ScreenTimeWarningThreshold`をguardianモジュールに追加した。
- データ書き出し要求の連続送信を防ぐ純関数`DataExportRequestThrottle`を
  privacyモジュールに追加した。
- 保護者ゲート認証情報のローテーション促進を判定する純関数
  `GuardianPinRotationReminder`をguardianモジュールに追加した。
- ストアアイテムの価格下落通知を判定する純関数`ItemPriceDropNotice`
  （`SeenItemPrice`）をgrowthモジュールに追加した。
- ギフト付与時の重複チェックを行う純関数`InventoryDuplicateGiftGuard`を
  growthモジュールに追加した。
- 同期キューの滞留を検知する純関数`SyncQueueBacklogAlert`をsyncモジュール
  に追加した。
- ストリーク保護用フリーズ券の消費判定を行う純関数
  `MissionStreakFreezeToken`をgrowthモジュールに追加した。
- 保護者向け通知の連続送信を抑制する純関数
  `GuardianNotificationDigestThrottle`をguardianモジュールに追加した。
- 解答時間の異常値検知を行う純関数`AnswerLatencyOutlierFlag`をadaptive
  モジュールに追加した。
- 保護者同意の期限切れ前リマインドを判定する純関数
  `ConsentRenewalReminder`をprivacyモジュールに追加した。
- 成長段階の後退を検知する純関数`GrowthStageRegressionGuard`をgrowth
  モジュールに追加した。
- 長時間オフラインギャップを検知する純関数`OfflineSessionGapDetector`を
  syncモジュールに追加した。
- プロフィール写真同意失効時の保存済み写真削除要否を判定する純関数
  `PhotoConsentExpiryCascade`をprivacyモジュールに追加した。
- 連続するミッション見逃しに上限を設ける純関数`MissionSkipStreakCap`を
  growthモジュールに追加した。
- 保護者承認申請の期限切れ前リマインドを判定する純関数
  `GuardianApprovalRequestReminderEscalation`をguardianモジュールに
  追加した。
- 長期間放置された弱点ノートの整理要否を判定する純関数
  `WeakNoteStalenessCleanup`をweakモジュールに追加した。
- 購入復元プロンプト要否を判定する純関数`EntitlementRestorePrompt`を
  entitlementモジュールに追加した。
- 効果音再生時のBGMダッキング判定を行う純関数
  `AudioCueVolumeDuckingSuggestion`をaudioモジュールに追加した。
- プロフィール切り替えが発生したことを保護者向けに記録すべきか判定する
  `ProfileSwitchAuditLog`をprofileモジュールに追加した。
- コインウォレットの残高不足を例外なしで事前確認できる
  `CoinWalletOverdraftGuard`をgrowthモジュールに追加した。
- タイムゾーン変更が連続観測された場合のみ再確認を促す
  `TimeZoneDriftRecalibrationPrompt`をregionalモジュールに追加した。
- 日次ダイジェストの同日重複送信を抑制する
  `DailyDigestDuplicateSuppression`をguardianモジュールに追加した。
- アプリのダウングレード等によるマイグレーション台帳の異常を検知する
  `MigrationLedgerRollbackGuard`をstoreモジュールに追加した。
- 出題が同一単元に偏っていないかを検知する`QuestionVarietyBiasDetector`を
  adaptiveモジュールに追加した。
- 保護者レポート未読が長期化した際の通知エスカレーションを判定する
  `ReportReadTimeoutEscalation`をguardianモジュールに追加した。
- ストリークが途切れそうな日の残り時間が少ない場合にアラートする
  `StreakRiskAlert`をgrowthモジュールに追加した。
- 同期コンフリクトの深刻度を分類する`SyncConflictSeverityClassifier`を
  syncモジュールに追加した。
- 保護者ゲートへの異常に速い連続試行を検知する
  `GuardianGateRapidAttemptDetector`をguardianモジュールに追加した。
- セッション中の解答時間が徐々に遅くなる傾向（集中力低下の疑い）を検知する
  `AnswerLatencyFatigueTrend`をadaptiveモジュールに追加した。
- 期間限定の所持アイテムの消費期限が近いことを知らせる
  `InventoryItemExpiryNotice`をgrowthモジュールに追加した。
- 複数端末から同じ内容のデータが重複して同期キューに積まれていないかを
  検知する`DuplicateSyncPayloadDetector`をsyncモジュールに追加した。
- ミッション達成履歴から最も学習しやすい時間帯を推定する
  `MissionCompletionTimePreference`をgrowthモジュールに追加した。
- 保護者承認待ちが複数件溜まった場合にまとめて知らせるべきかを判定する
  `GuardianApprovalRequestBatchNotice`をguardianモジュールに追加した。
- 一度克服したはずの誤解が再び誤答として現れた（再発した）かを検知する
  `WeakNoteMisconceptionRelapse`をweakモジュールに追加した。
- 子どもと保護者の端末のタイムゾーンが大きくずれていないかを検知する
  `GuardianTimezoneMismatchDetector`をguardianモジュールに追加した。
- データ書き出しのJSON化後のバイト数を見積もり、分割が必要かを判定する
  `ExportSizeEstimator`をprivacyモジュールに追加した。
- 課金プランの有効期限切れが近いことを事前に知らせるべきかを判定する
  `EntitlementExpiryNotice`をentitlementモジュールに追加した。
- コイン残高が長期間使われず滞留していることに気づけるようにする
  `CoinWalletStagnationNotice`をgrowthモジュールに追加した。
- 兄弟プロフィール間で学習時間の配分が極端に偏っていないかを検知する
  `SiblingProfileUsageBalance`をprofileモジュールに追加した。
- セッション内の解答が復習モードに偏りすぎていないかを検知する
  `SessionReviewModeRatioAlert`をadaptiveモジュールに追加した。
- プロフィール写真が登録・最終更新から長期間変わっていないことに気づ
  けるようにする`ProfilePhotoStalenessNotice`をprofileモジュールに
  追加した。
- 週次レポートの既読率が継続して低い場合に通知方法の見直しを提案する
  `WeeklyReportEngagementDeclineNotice`をguardianモジュールに追加した。
- 保護者ゲートのPINが連番や同一数字の繰り返しのような推測されやすい
  パターンでないかを検知する`GuardianPinWeaknessDetector`をguardian
  モジュールに追加した。
- 単元推薦が何度も提示されても学習されずに無視され続けていないかを
  検知する`UnitRecommendationIgnoredDetector`をquestionモジュールに
  追加した。
- `MasteryDecay`の減衰量が大きい単元を優先的に知らせるべきかを判定する
  `MasteryRapidDecayDetector`をquestionモジュールに追加した。
- 設定バックアップが長期間作成されていないことに気づけるようにする
  `SettingsBackupStalenessNotice`をprivacyモジュールに追加した。
- 同期の再送を諦めたアイテムが溜まった場合にオフライン専用モードへの
  切り替えを提案する`OfflineOnlyModeSuggestion`をsyncモジュールに
  追加した。
- `eraseAllUserData`実行後に関連ストアが実際に空になったかを検証する
  `DataErasureVerifier`をprivacyモジュールに追加した。
- 同一プロファイルのデータが短時間に複数デバイスから更新されている
  可能性を検知する`MultiDeviceConcurrentEditDetector`をsyncモジュール
  に追加した。
- 保護者向け通知の配信が連続して失敗している場合に代替通知手段を
  提案する`GuardianDeliveryFailureAlternativeNotice`をguardianモジュール
  に追加した。
- 速すぎる解答が連続していないか（不正操作の可能性）を検知する
  `RapidAnswerStreakDetector`をadaptiveモジュールに追加した。
- 季節イベントの終了判定が端末時刻のタイムゾーンズレで誤判定されて
  いないかを検証する`SeasonalEventValidityGuard`をgrowthモジュールに
  追加した。
- 購入復元が長期間実行されていないことに気づけるようにする
  `EntitlementRestoreStalenessNotice`をentitlementモジュールに追加した。
- 音声のミュートが長期間解除されずに続いている場合に解除確認を提案する
  `AudioMuteStalenessNotice`をaudioモジュールに追加した。
- 未解除の達成バッジについて条件達成までの残り回数を算出する
  `AchievementProximityHint`をgrowthモジュールに追加した。
- 単元の提示順と難易度の想定順序（易→難）が逆転していないかを検証する
  `UnitDifficultyOrderValidator`をquestionモジュールに追加した。
- 同一内容の保護者承認リクエストが短時間に重複して作成されていないかを
  検知する`GuardianApprovalRequestDuplicateDetector`をguardianモジュール
  に追加した。
- 同期キュー1件分のペイロードサイズが異常に大きい場合に気づける
  `SyncPayloadSizeAlert`をsyncモジュールに追加した。
- 同一内容の通知が短時間に重複して予約されていないかを検知する
  `DuplicateNotificationScheduleDetector`をnotifyモジュールに追加した。
- データ書き出しが長期間再生成されていないことに気づける
  `DataExportRenewalNotice`をprivacyモジュールに追加した。
- 短時間に大きなコイン消費が連続していないか（想定外の連続購入）を
  検知する`RapidCoinSpendingStreakDetector`をgrowthモジュールに追加した。
- プロフィール写真利用の同意取得から長期間経過していることに気づける
  `ProfilePhotoConsentRenewalNotice`をprivacyモジュールに追加した。
- デイリーリマインド送信後もミッションが連続して未達成のまま終わって
  いないかを検知する`DailyReminderNonresponseStreakDetector`をnotify
  モジュールに追加した。
- 弱点ノートの復習期限を大幅に超えて放置されている単元を検知する
  `WeakNoteReviewOverdueEscalation`をweakモジュールに追加した。
- 現在のロケール向けのカリキュラムが未読み込みであることに気づける
  `LocaleCurriculumStalenessNotice`をregionalモジュールに追加した。
- 保護者ゲートのロックが解除間近であることを事前に知らせるべきかを判定する
  `GuardianGateLockoutEndingSoonNotice`をguardianモジュールに追加した。
- 単元マスタリーバッジ解除直後の学習意欲低下を検知する
  `UnitMasteryBadgeMotivationDropNotice`をgrowthモジュールに追加した。
- エンタイトルメント猶予期間の終了間近を事前に知らせるべきかを判定する
  `EntitlementGracePeriodEndingSoonReminder`をentitlementモジュールに
  追加した。
- デイリーミッションが同じ種類ばかり連続して出題されているマンネリ化
  状態を検知する`DailyMissionMonotonyDetector`をgrowthモジュールに
  追加した。
- 購入復元の試行が連続して失敗している状態を検知する
  `EntitlementRestoreFailureStreak`をentitlementモジュールに追加した。
- 保護者週次レポートが開封されたが閲覧時間が短く流し見状態である
  ことを検知する`WeeklyReportSkimDetector`をguardianモジュールに
  追加した。
- 同一レコードで同期コンフリクトが繰り返し発生している再発状態を検知する
  `SyncConflictRecurrenceDetector`をsyncモジュールに追加した。
- 適応難易度の算出結果が一定期間変化していない停滞状態を検知する
  `AdaptiveDifficultyPlateauDetector`をadaptiveモジュールに追加した。
- 日次コイン獲得上限に連日到達し続けている常態化状態を検知する
  `CoinEarningCapHabitualHitDetector`をgrowthモジュールに追加した。
- 入手済みのインベントリアイテムが長期間使用されていない状態を検知する
  `InventoryItemStaleUsageNotice`をgrowthモジュールに追加した。
- データエクスポートの試行が連続して失敗している状態を検知する
  `DataExportFailureStreak`をprivacyモジュールに追加した。
- ストリークフリーズトークンが使われずに失効し続けている無駄遣い状態を
  検知する`StreakFreezeTokenWasteDetector`をgrowthモジュールに追加した。
- 同期待ちアイテムのうちバックオフ上限に達した件数の割合からシステム的
  な同期障害の可能性を検知する`RetryBackoffExhaustionRateAlert`をsync
  モジュールに追加した。
- プロフィール切替直後にすぐ元へ戻す誤操作パターンを検知する
  `ProfileSwitchRevertDetector`をprofileモジュールに追加した。
- 承認待ちの保護者承認申請が一定数を超えて積み上がっている滞留状態を
  検知する`GuardianApprovalRequestBacklogSizeAlert`をguardianモジュール
  に追加した。
- 未解消の弱点ノート件数が一定数を超えて増え続けている積み上がり状態を
  検知する`WeakNoteBacklogSizeAlert`をweakモジュールに追加した。
- 短時間オンライン→すぐオフラインのパターンが頻発している不安定な接続
  状態を検知する`FlakyConnectivityDetector`をsyncモジュールに追加した。
- 直近の出題に同じ問題が繰り返し出されすぎている疲労状態を検知する
  `QuestionRepetitionFatigueDetector`をadaptiveモジュールに追加した。
- 同期待ちキュー内で特定のアイテムだけが著しく長く待たされている
  スタベーション状態を検知する`PendingSyncItemStarvationDetector`を
  syncモジュールに追加した。
- 未使用のまま保持しているインベントリアイテムの種類数が一定数を超えて
  いる状態を検知する`InventoryItemUnusedVarietyAlert`をgrowthモジュール
  に追加した。
- 短時間にアバター変更が繰り返されている場合に変更を制限すべきかを
  判定する`ProfileAvatarChangeFrequencyThrottle`をprofileモジュールに
  追加した。
- 1つの単元の弱点ノートが同時に多種類の誤解タイプに広がっている状態を
  検知する`WeakNoteMisconceptionDiversityAlert`をweakモジュールに追加した。
- 内容の異同に関わらず複数の通知予定が短時間に密集している状態を検知
  する`NotificationScheduleClusteringDetector`をnotifyモジュールに
  追加した。
- 保護者が却下した承認申請が長期間再提出されずに放置されている状態を
  検知する`GuardianApprovalRequestStaleRejectionReminder`をguardian
  モジュールに追加した。
- キャッシュされた地域プロフィールと最新のプロフィールの内容差分を
  検知する`RegionalProfileChangeDetector`をregionalモジュールに追加した。
- 直近の解答時間が継続的に短縮している習熟傾向を検知する
  `AnswerLatencyImprovementTrendDetector`をadaptiveモジュールに追加した。
- 成長段階が最後の進化から長期間変化していない停滞状態を検知する
  `GrowthStageStallDetector`をgrowthモジュールに追加した。
- 同期競合解決の直後、一定時間内であれば取り消しを許可すべきかを判定
  する`SyncConflictResolutionUndoWindow`をsyncモジュールに追加した。
- 課金サイクルごとに猶予期間が繰り返し使われているパターンを検知する
  `EntitlementGracePeriodRepeatedUsageDetector`をentitlementモジュール
  に追加した。
- アプリが認識しているが未適用のまま残っているマイグレーションを検知
  する`MigrationLedgerPendingMigrationAlert`をstoreモジュールに追加した。
- 保護者が利用時間制限を頻繁に一時解除している状態を検知する
  `ScreenTimeGuardOverrideFrequencyAlert`をguardianモジュールに追加した。
- 複数のバッジが同時に解除された際に祝賀表示を分散させるべきかを判定
  する`AchievementUnlockClusterDetector`をgrowthモジュールに追加した。
- 同意履歴に長期間イベントが記録されていない空白期間を検知する
  `ConsentAuditLogGapDetector`をprivacyモジュールに追加した。
- 残高不足で購入できない状態が連続していることを検知する
  `InventoryManagerInsufficientBalanceStreakDetector`をgrowthモジュール
  に追加した。
- 週次レポートが複数週連続で未読のまま放置されている状態を検知する
  `WeeklyReportUnopenedStreakDetector`をguardianモジュールに追加した。
- 長時間オフラインから復帰し同期が完了した際に案内すべきかを判定する
  `OfflineSessionResumeNotice`をsyncモジュールに追加した。
- 1日あたりのコイン消費上限に連日到達し続けている常態化状態を検知する
  `CoinSpendingLimitHabitualMaxOutDetector`をgrowthモジュールに追加した。
- 同じ音声キューが直近の再生で繰り返しすぎている疲労状態を検知する
  `AudioCueRepetitionFatigueDetector`をaudioモジュールに追加した。
- 購入復元プロンプトが連続して無視され続けている状態を検知する
  `EntitlementRestorePromptDismissalStreakDetector`をentitlement
  モジュールに追加した。
- 保護者承認申請が連続して却下され続けている状態を検知する
  `GuardianApprovalRequestRepeatedRejectionStreakDetector`をguardian
  モジュールに追加した。
- 弱点ノートの復習セッションが連続してスキップされている状態を検知する
  `WeakNoteReviewSkipStreakDetector`をweakモジュールに追加した。
- アバター変更の提案が連続して無視され続けている状態を検知する
  `ProfileAvatarRotationSuggestionIgnoredDetector`をprofileモジュール
  に追加した。
- 適応難易度が上下に反転し続けて安定しない振動状態を検知する
  `AdaptiveDifficultyOscillationDetector`をadaptiveモジュールに追加した。
- PINローテーション後に過去と同じPINが再利用されている状態を検知する
  `GuardianPinReuseAfterRotationDetector`をguardianモジュールに追加した。
- ストリークフリーズトークンが失効する前に案内すべきかを判定する
  `MissionStreakFreezeTokenExpiryWarning`をgrowthモジュールに追加した。
- 直近の出題でのヒント利用回数から過度な依存が続いているかを検知する
  `QuestionHintOverrelianceDetector`をquestionモジュールに追加した。
- 短時間に何度もニックネーム変更が繰り返されることを制限する
  `ProfileNicknameChangeFrequencyThrottle`をprofileモジュールに追加した。
- 達成共有カードが短時間に連続して共有されすぎないようクールダウンを
  判定する`AchievementShareCardCooldown`をgrowthモジュールに追加した。
- 保護者承認申請への応答所要時間が悪化傾向にあるかを検知する
  `GuardianApprovalRequestLatencyTrend`をguardianモジュールに追加した。
- 弱点ノート復習完了後の再テストスコアが悪化しているかを検知する
  `WeakNoteReviewScoreRegressionDetector`をweakモジュールに追加した。
- 同期コンフリクトの解決が常に同じ側に偏っているかを検知する
  `SyncConflictResolutionChoiceBiasDetector`をsyncモジュールに追加した。
- ダッキング推奨音量がユーザーに頻繁に上書きされているかを検知する
  `AudioCueVolumeDuckingOverrideFrequencyDetector`をaudioモジュールに
  追加した。
- 地域プロファイルの読み込みが連続して失敗しフォールバックが続いて
  いる状態を知らせる`RegionalProfileLoadFailureFallbackNotice`を
  regionalモジュールに追加した。
- 設定バックアップの復元が連続して失敗している状態を検知する
  `SettingsBackupRestoreFailureStreak`をprivacyモジュールに追加した。
- 解答時間のバラつきが急増しているかを検知する
  `AnswerLatencyVarianceSpikeDetector`をadaptiveモジュールに追加した。
- 静かな時間帯明け直後への再スケジュールが複数件同一時刻に衝突して
  いないかを検知する`NotificationQuietMergeCollisionDetector`を
  notifyモジュールに追加した。
- 端末ロケール提案と異なるロケールが連続して選ばれ続けている状態を
  検知する`DeviceLocaleSuggestionIgnoredDetector`をregionalモジュール
  に追加した。
- 複数単元の習熟度が揃って停滞しているかを検知する
  `MasteryAcrossUnitsStagnationDetector`をprogressモジュールに追加した。
- 未解消の弱点ノート件数の増加速度が加速しているかを検知する
  `WeakNoteBacklogGrowthRateAlert`をweakモジュールに追加した。
- プロフィール切替の誤操作が連続して繰り返されているかを検知する
  `ProfileSwitchRevertStreakDetector`をprofileモジュールに追加した。
- 長時間オフラインギャップが習慣的に繰り返されているかを検知する
  `OfflineSessionGapRecurrenceDetector`をsyncモジュールに追加した。
- 保護者ゲートのロックアウトが日をまたいで繰り返し発生しているかを
  検知する`GuardianGateLockoutRepeatedTriggerDetector`をguardian
  モジュールに追加した。
- 同期バックオフ枯渇によるシステム的障害判定が連続して発生している
  かを検知する`RetryBackoffExhaustionRecurrenceDetector`をsync
  モジュールに追加した。
- 間隔反復の復習期限到来件数が積み上がっているかを検知する
  `SpacedReviewOverdueBacklogAlert`をweakモジュールに追加した。
- 保護者同意の再同意リマインドが連続して無視され続けている状態を
  検知する`ConsentRenewalReminderDismissalStreakDetector`をprivacy
  モジュールに追加した。
- 単元マスターバッジ獲得後に正答率が再び悪化しているかを検知する
  `UnitMasteryBadgeAccuracyRegressionDetector`をgrowthモジュールに
  追加した。
- 課金期限切れ事前通知が連続して無視され続けている状態を検知する
  `EntitlementExpiryNoticeDismissalStreakDetector`をentitlement
  モジュールに追加した。
- 同一内容の通知の重複予約が繰り返し発生している状態を検知する
  `DuplicateNotificationScheduleRecurrenceDetector`をnotifyモジュールに
  追加した。
- 週次レポートが複数週にわたって連続で流し見されている状態を検知する
  `WeeklyReportSkimStreakDetector`をguardianモジュールに追加した。
- 直近の解答の正答率が前半と比べて後半に悪化している傾向を判定する
  `AnswerAccuracyDeclineTrendDetector`をadaptiveモジュールに追加した。
- 効果音/BGMのミュート/解除の切り替えが短時間に頻発している状態を検知
  する`AudioMuteToggleFrequencyDetector`をaudioモジュールに追加した。
- 習熟度の減衰量が複数回の確認にわたって悪化し続けている状態を検知する
  `MasteryDecayAccelerationDetector`をquestionモジュールに追加した。
- プロフィール写真利用同意の再確認が連続して無視され続けている状態を
  検知する`ProfilePhotoConsentRenewalDismissalStreakDetector`をprivacy
  モジュールに追加した。
- まとめ送り抑制された保護者向け通知が一定件数以上積み上がっている
  状態を検知する`GuardianNotificationBacklogSizeAlert`をguardian
  モジュールに追加した。
- 未解消の弱点ノートのうち最も古いものがどれだけ放置されているかを
  検知する`WeakNoteBacklogOldestItemAgeAlert`をweakモジュールに追加した。
- 一度学習を始めた単元が長期間再学習されず未習熟のまま放置されている
  状態を検知する`UnitAbandonmentDetector`をprogressモジュールに追加した。
- 間隔反復の箱レベルが連続して0に戻され続けている問題を検知する
  `SpacedReviewBoxLevelRegressionStreakDetector`をweakモジュールに
  追加した。
- 猶予期間終了間近の通知が連続して無視され続けている状態を検知する
  `EntitlementGracePeriodEndingSoonReminderDismissalStreakDetector`を
  entitlementモジュールに追加した。
- 学習ストリークの見逃し猶予が連続して使われ続けている状態を検知する
  `StreakRecoveryGraceRepeatedUsageDetector`をgrowthモジュールに追加した。
- 保護者ゲートのPINローテーション催促が連続して無視され続けている状態
  を検知する`GuardianPinRotationReminderDismissalStreakDetector`を
  guardianモジュールに追加した。
- ダッキング推奨音量が連続して上書きされ続けている状態を検知する
  `AudioCueVolumeDuckingOverrideStreakDetector`をaudioモジュールに
  追加した。
- 学習記録書き出しの再発行提案が連続して無視され続けている状態を検知する
  `DataExportRenewalNoticeDismissalStreakDetector`をprivacyモジュールに
  追加した。
- 設定バックアップの催促が連続して無視され続けている状態を検知する
  `SettingsBackupStalenessNoticeDismissalStreakDetector`をprivacy
  モジュールに追加した。
- コイン残高滞留の通知が連続して無視され続けている状態を検知する
  `CoinWalletStagnationNoticeDismissalStreakDetector`をgrowthモジュール
  に追加した。
- 期間限定アイテムの消費期限切れ事前通知が連続して無視され続けている
  状態を検知する`InventoryItemExpiryNoticeDismissalStreakDetector`を
  growthモジュールに追加した。
- ストリークフリーズトークンの失効間近警告が連続して無視され続けている
  状態を検知する`MissionStreakFreezeTokenExpiryWarningDismissalStreakDetector`
  をgrowthモジュールに追加した。
- ストアアイテムの値下げ通知が連続して無視され続けている状態を検知する
  `ItemPriceDropNoticeDismissalStreakDetector`をgrowthモジュールに
  追加した。
- 保護者ゲートのロック解除間近通知が連続して無視され続けている状態を
  検知する`GuardianGateLockoutEndingSoonNoticeDismissalStreakDetector`
  をguardianモジュールに追加した。
- 購入復元の長期未実行通知が連続して無視され続けている状態を検知する
  `EntitlementRestoreStalenessNoticeDismissalStreakDetector`を
  entitlementモジュールに追加した。
- プロフィール写真の更新案内通知が連続して無視され続けている状態を
  検知する`ProfilePhotoStalenessNoticeDismissalStreakDetector`を
  profileモジュールに追加した。
- 単元マスター直後の学習意欲低下通知が連続して無視され続けている状態を
  検知する`UnitMasteryBadgeMotivationDropNoticeDismissalStreakDetector`
  をgrowthモジュールに追加した。
- タイムゾーン再確認プロンプトが連続して無視され続けている状態を検知する
  `TimeZoneDriftRecalibrationPromptDismissalStreakDetector`をregional
  モジュールに追加した。
- ストリーク途切れ警告が連続して無視され続けている状態を検知する
  `StreakRiskAlertDismissalStreakDetector`をgrowthモジュールに追加した。
- 地域プロファイル読み込み失敗通知が連続して無視され続けている状態を
  検知する`RegionalProfileLoadFailureFallbackNoticeDismissalStreakDetector`
  をregionalモジュールに追加した。
- 保護者向け代替通知手段の提案が連続して無視され続けている状態を検知する
  `GuardianDeliveryFailureAlternativeNoticeDismissalStreakDetector`を
  guardianモジュールに追加した。
- 週次レポートの通知方法見直し提案が連続して無視され続けている状態を
  検知する`WeeklyReportEngagementDeclineNoticeDismissalStreakDetector`を
  guardianモジュールに追加した。
- 保護者承認申請の却下後の再提出案内が連続して無視され続けている状態を
  検知する`GuardianApprovalRequestStaleRejectionReminderDismissalStreakDetector`
  をguardianモジュールに追加した。
- 未使用インベントリアイテムの使用案内が連続して無視され続けている状態を
  検知する`InventoryItemStaleUsageNoticeDismissalStreakDetector`を
  growthモジュールに追加した。
- 保護者承認待ちまとめ通知が連続して無視され続けている状態を検知する
  `GuardianApprovalRequestBatchNoticeDismissalStreakDetector`をguardian
  モジュールに追加した。
- ミュート解除確認提案が連続して無視され続けている状態を検知する
  `AudioMuteStalenessNoticeDismissalStreakDetector`をaudioモジュールに
  追加した。
- ロケール切替後のカリキュラム未読み込み通知が連続して無視され続けている
  状態を検知する`LocaleCurriculumStalenessNoticeDismissalStreakDetector`
  をregionalモジュールに追加した。
- 難易度急変アラートが連続して無視され続けている状態を検知する
  `QuestionDifficultyDriftAlertDismissalStreakDetector`をadaptive
  モジュールに追加した。
- 保護者承認申請の滞留アラートが連続して無視され続けている状態を検知する
  `GuardianApprovalRequestBacklogSizeAlertDismissalStreakDetector`を
  guardianモジュールに追加した。
- 復習モード偏りアラートが連続して無視され続けている状態を検知する
  `SessionReviewModeRatioAlertDismissalStreakDetector`をadaptive
  モジュールに追加した。
- 誤解多様化アラートが連続して無視され続けている状態を検知する
  `WeakNoteMisconceptionDiversityAlertDismissalStreakDetector`をweak
  モジュールに追加した。
- 保護者向け通知積み上がりアラートが連続して無視され続けている状態を
  検知する`GuardianNotificationBacklogSizeAlertDismissalStreakDetector`
  をguardianモジュールに追加した。
- 未使用インベントリアイテム種類数アラートが連続して無視され続けている
  状態を検知する`InventoryItemUnusedVarietyAlertDismissalStreakDetector`
  をgrowthモジュールに追加した。
- 利用時間制限の頻繁な一時解除アラートが連続して無視され続けている
  状態を検知する
  `ScreenTimeGuardOverrideFrequencyAlertDismissalStreakDetector`を
  guardianモジュールに追加した。
- 未適用マイグレーションアラートが連続して無視され続けている状態を
  検知する`MigrationLedgerPendingMigrationAlertDismissalStreakDetector`
  をstoreモジュールに追加した。
- 同期キュー滞留アラートが連続して無視され続けている状態を検知する
  `SyncQueueBacklogAlertDismissalStreakDetector`をsyncモジュールに
  追加した。
- 弱点ノート積み上がりアラートが連続して無視され続けている状態を
  検知する`WeakNoteBacklogSizeAlertDismissalStreakDetector`をweak
  モジュールに追加した。
- 長時間オフライン後の同期完了案内が連続して無視され続けている状態を
  検知する`OfflineSessionResumeNoticeDismissalStreakDetector`をsync
  モジュールに追加した。
- システム的同期障害アラートが連続して無視され続けている状態を検知する
  `RetryBackoffExhaustionRateAlertDismissalStreakDetector`をsync
  モジュールに追加した。
- 間隔反復復習の積み上がりアラートが連続して無視され続けている状態を
  検知する`SpacedReviewOverdueBacklogAlertDismissalStreakDetector`を
  weakモジュールに追加した。
- 同期ペイロードサイズ異常アラートが連続して無視され続けている状態を
  検知する`SyncPayloadSizeAlertDismissalStreakDetector`をsyncモジュール
  に追加した。
- 弱点ノート急増アラートが連続して無視され続けている状態を検知する
  `WeakNoteBacklogGrowthRateAlertDismissalStreakDetector`をweak
  モジュールに追加した。
- 最古弱点ノート放置アラートが連続して無視され続けている状態を検知する
  `WeakNoteBacklogOldestItemAgeAlertDismissalStreakDetector`をweak
  モジュールに追加した。
- 地域プロフィールの内容変化が繰り返し検出され続けている状態を検知する
  `RegionalProfileChangeRecurrenceDetector`をregionalモジュールに
  追加した。
- 子どもと保護者のタイムゾーン不一致が繰り返し検出され続けている状態を
  検知する`GuardianTimezoneMismatchRecurrenceDetector`をguardian
  モジュールに追加した。
- 複数デバイスからの同時編集の可能性が繰り返し検出され続けている状態を
  検知する`MultiDeviceConcurrentEditRecurrenceDetector`をsyncモジュール
  に追加した。
- ヒントへの過度な依存が繰り返し検出され続けている状態を検知する
  `QuestionHintOverrelianceRecurrenceDetector`をquestionモジュールに
  追加した。
- 同期キュー内の重複ペイロードが繰り返し検出され続けている状態を検知する
  `DuplicateSyncPayloadRecurrenceDetector`をsyncモジュールに追加した。
- 単元放置が繰り返し検出され続けている状態を検知する
  `UnitAbandonmentRecurrenceDetector`をprogressモジュールに追加した。
- 復習後の再テストスコア悪化が繰り返し検出され続けている状態を検知する
  `WeakNoteReviewScoreRegressionRecurrenceDetector`をweakモジュールに
  追加した。
- 同意履歴の記録空白が繰り返し検出され続けている状態を検知する
  `ConsentAuditLogGapRecurrenceDetector`をprivacyモジュールに追加した。
- 複数単元習熟度の全体的な停滞が繰り返し検出され続けている状態を検知する
  `MasteryAcrossUnitsStagnationRecurrenceDetector`をprogressモジュールに
  追加した。
- タイムゾーン変更が繰り返し検出され続けている状態を検知する
  `TimeZoneDriftRecurrenceDetector`をregionalモジュールに追加した。
- 同期待ちアイテムのスタベーションが繰り返し検出され続けている状態を
  検知する`PendingSyncItemStarvationRecurrenceDetector`をsyncモジュール
  に追加した。
- 保護者承認待ち申請の重複が繰り返し検出され続けている状態を検知する
  `GuardianApprovalRequestDuplicateRecurrenceDetector`をguardianモジュール
  に追加した。
- 成長段階の停滞が繰り返し検出され続けている状態を検知する
  `GrowthStageStallRecurrenceDetector`をgrowthモジュールに追加した。
- 習熟度の急激な減衰が繰り返し検出され続けている状態を検知する
  `MasteryRapidDecayRecurrenceDetector`をquestionモジュールに追加した。
- 保護者ゲートへの異常に速い連続試行が繰り返し検出され続けている状態を
  検知する`GuardianGateRapidAttemptRecurrenceDetector`をguardianモジュール
  に追加した。
- 単元マスターバッジ獲得後の正答率悪化が繰り返し検出され続けている状態を
  検知する`UnitMasteryBadgeAccuracyRegressionRecurrenceDetector`を
  growthモジュールに追加した。
- 実績の同時解除の密集が繰り返し検出され続けている状態を検知する
  `AchievementUnlockClusterRecurrenceDetector`をgrowthモジュールに追加
  した。
- 静かな時間帯明け後の通知の衝突が繰り返し検出され続けている状態を検知
  する`NotificationQuietMergeCollisionRecurrenceDetector`をnotifyモジュール
  に追加した。
- 成長段階の停滞が解消し連続して停滞なしと判定され続けている状態を検知
  する`GrowthStageStallRecoveryDetector`をgrowthモジュールに追加した。
- 習熟度の急激な減衰が収まり連続して急激な減衰なしと判定され続けている
  状態を検知する`MasteryRapidDecayRecoveryDetector`をquestionモジュール
  に追加した。
- 同期待ちアイテムのスタベーションが解消し連続してスタベーションなしと
  判定され続けている状態を検知する`PendingSyncItemStarvationRecoveryDetector`
  をsyncモジュールに追加した。
- 保護者ゲートへの異常に速い連続試行が収まり連続して正常な試行間隔と
  判定され続けている状態を検知する`GuardianGateRapidAttemptRecoveryDetector`
  をguardianモジュールに追加した。
- 単元マスターバッジ獲得後の正答率悪化が収まり連続して悪化なしと判定
  され続けている状態を検知する`UnitMasteryBadgeAccuracyRegressionRecoveryDetector`
  をgrowthモジュールに追加した。
- 弱点ノート再テストスコアの悪化が収まり連続して悪化なしと判定され
  続けている状態を検知する`WeakNoteReviewScoreRegressionRecoveryDetector`
  をweakモジュールに追加した。
- 長時間オフラインが解消し連続して短い起動間隔が続いている状態を検知
  する`OfflineSessionGapRecoveryDetector`をsyncモジュールに追加した。
- 保護者承認待ち申請の重複が解消し連続して重複なしと判定され続けている
  状態を検知する`GuardianApprovalRequestDuplicateRecoveryDetector`を
  guardianモジュールに追加した。
- タイムゾーンの変化が収まり連続して変化なしと判定され続けている状態を
  検知する`TimeZoneDriftRecoveryDetector`をregionalモジュールに追加した。
- 子どもと保護者の端末間のタイムゾーン不一致が解消し連続して一致と
  判定され続けている状態を検知する`GuardianTimezoneMismatchRecoveryDetector`
  をguardianモジュールに追加した。
- 同意履歴の記録空白が解消し連続して記録が続いている状態を検知する
  `ConsentAuditLogGapRecoveryDetector`をprivacyモジュールに追加した。
- 地域プロフィールの変化が収まり連続して変化なしと判定され続けている
  状態を検知する`RegionalProfileChangeRecoveryDetector`をregionalモジュール
  に追加した。
- 複数単元の習熟度の全体的な停滞が解消し連続して停滞なしと判定され
  続けている状態を検知する`MasteryAcrossUnitsStagnationRecoveryDetector`
  をprogressモジュールに追加した。
- 単元の放置状態が解消し連続して放置なしと判定され続けている状態を
  検知する`UnitAbandonmentRecoveryDetector`をprogressモジュールに追加した。
- 同期キュー内のペイロード重複が解消し連続して重複なしと判定され続け
  ている状態を検知する`DuplicateSyncPayloadRecoveryDetector`をsyncモジュール
  に追加した。
- 実績の同時解除の密集が解消し連続して密集なしと判定され続けている
  状態を検知する`AchievementUnlockClusterRecoveryDetector`をgrowthモジュール
  に追加した。
- 同一内容の通知の重複予約が解消し連続して重複なしと判定され続けている
  状態を検知する`DuplicateNotificationScheduleRecoveryDetector`をnotify
  モジュールに追加した。
- 複数デバイスからの同時編集の可能性が解消し連続してなしと判定され
  続けている状態を検知する`MultiDeviceConcurrentEditRecoveryDetector`
  をsyncモジュールに追加した。
- 静かな時間帯明け後の通知の衝突が解消し連続して衝突なしと判定され
  続けている状態を検知する`NotificationQuietMergeCollisionRecoveryDetector`
  をnotifyモジュールに追加した。
- システム的な同期障害の判定が解消し連続してなしと判定され続けている
  状態を検知する`RetryBackoffExhaustionRecoveryDetector`をsyncモジュール
  に追加した。
- 週次レポートの流し見状態が解消し連続してしっかり閲覧され続けている
  状態を検知する`WeeklyReportSkimRecoveryDetector`をguardianモジュール
  に追加した。
- 誤操作らしきプロフィール切替が解消し連続してなしと判定され続けている
  状態を検知する`ProfileSwitchRevertRecoveryDetector`をprofileモジュール
  に追加した。
- 同一レコードでの同期コンフリクトの再発が解消し連続してコンフリクト
  なしと判定され続けている状態を検知する`SyncConflictRecoveryDetector`
  をsyncモジュールに追加した。
- 通知予定の時間的密集が解消し連続して密集なしと判定され続けている
  状態を検知する`NotificationScheduleClusteringRecoveryDetector`をnotify
  モジュールに追加した。
- 解答時間のバラつきの急増が解消し連続して安定していると判定され続け
  ている状態を検知する`AnswerLatencyVarianceSpikeRecoveryDetector`を
  adaptiveモジュールに追加した。
- デイリーミッションのマンネリ化が解消し連続して種類の多様性が戻って
  いると判定され続けている状態を検知する
  `DailyMissionMonotonyRecoveryDetector`をgrowthモジュールに追加した。
- 難易度の停滞が解消し連続して難易度が変化していると判定され続けて
  いる状態を検知する`AdaptiveDifficultyPlateauRecoveryDetector`を
  adaptiveモジュールに追加した。
- 不安定な接続状態が解消し連続して安定していると判定され続けている
  状態を検知する`FlakyConnectivityRecoveryDetector`をsyncモジュール
  に追加した。
- 同一問題の繰り返し出題による疲労状態が解消し連続して多様な出題と
  判定され続けている状態を検知する
  `QuestionRepetitionFatigueRecoveryDetector`をadaptiveモジュールに
  追加した。
- 同一音声キューの繰り返し再生による疲労状態が解消し連続して多様な
  再生と判定され続けている状態を検知する
  `AudioCueRepetitionFatigueRecoveryDetector`をaudioモジュールに
  追加した。
- 出題タグの偏りが解消し連続して多様性が戻っていると判定され続けて
  いる状態を検知する`QuestionVarietyBiasRecoveryDetector`をadaptive
  モジュールに追加した。
- 正答率の悪化傾向が解消し連続して正答率が安定していると判定され
  続けている状態を検知する`AnswerAccuracyDeclineTrendRecoveryDetector`
  をadaptiveモジュールに追加した。
- 同期コンフリクト解決の片側偏りが解消し連続してバランスが取れている
  と判定され続けている状態を検知する
  `SyncConflictResolutionChoiceBiasRecoveryDetector`をsyncモジュール
  に追加した。
- 日次コイン獲得上限への連日到達の常態化が解消し連続して上限未到達
  と判定され続けている状態を検知する
  `CoinEarningCapHabitualHitRecoveryDetector`をgrowthモジュールに
  追加した。
- 日次コイン消費上限への連日到達の常態化が解消し連続して上限未到達
  と判定され続けている状態を検知する
  `CoinSpendingLimitHabitualMaxOutRecoveryDetector`をgrowthモジュール
  に追加した。
- ミュート/解除の頻発な切り替えが解消し連続して頻発なしと判定され
  続けている状態を検知する`AudioMuteToggleFrequencyRecoveryDetector`
  をaudioモジュールに追加した。
- 推奨ダッキング音量への頻発な手動上書きが解消し連続して上書きなし
  と判定され続けている状態を検知する
  `AudioCueVolumeDuckingOverrideFrequencyRecoveryDetector`をaudio
  モジュールに追加した。
- 難易度の振動状態が解消し連続して安定していると判定され続けている
  状態を検知する`AdaptiveDifficultyOscillationRecoveryDetector`を
  adaptiveモジュールに追加した。
- 単元提案の無視状態が解消し連続して着手されていると判定され続けて
  いる状態を検知する`UnitRecommendationIgnoredRecoveryDetector`を
  questionモジュールに追加した。
- 保護者ゲートのロックアウト繰り返し発生の閾値にあと少しで到達し
  そうな接近状態を検知する
  `GuardianGateLockoutRepeatedTriggerApproachingDetector`をguardian
  モジュールに追加した（新パターン：ApproachingDetector）。
- 猶予期間の繰り返し利用パターンの閾値にあと少しで到達しそうな接近
  状態を検知する`EntitlementGracePeriodRepeatedUsageApproachingDetector`
  をentitlementモジュールに追加した（ApproachingDetectorパターン）。
- ストリークフリーズトークンの無駄遣い判定の閾値にあと少しで到達
  しそうな接近状態を検知する`StreakFreezeTokenWasteApproachingDetector`
  をgrowthモジュールに追加した（ApproachingDetectorパターン）。
- 端末ロケール提案の連続無視判定の閾値にあと少しで到達しそうな接近
  状態を検知する`DeviceLocaleSuggestionIgnoredApproachingDetector`を
  regionalモジュールに追加した（ApproachingDetectorパターン）。
- プロフィールアバター回転提案の連続無視判定の閾値にあと少しで到達
  しそうな接近状態を検知する
  `ProfileAvatarRotationSuggestionIgnoredApproachingDetector`を
  profileモジュールに追加した（ApproachingDetectorパターン）。
- 習熟度減衰の悪化トレンド判定の閾値にあと少しで到達しそうな接近
  状態を検知する`MasteryDecayAccelerationApproachingDetector`を
  questionモジュールに追加した（ApproachingDetectorパターン）。
- 週次レポート連続未読放置判定の閾値にあと少しで到達しそうな接近
  状態を検知する`WeeklyReportUnopenedStreakApproachingDetector`を
  guardianモジュールに追加した（ApproachingDetectorパターン）。
- 残高不足購入不可連続判定の閾値にあと少しで到達しそうな接近状態を
  検知する`InventoryManagerInsufficientBalanceStreakApproachingDetector`
  をgrowthモジュールに追加した（ApproachingDetectorパターン）。
- 間隔反復の箱レベル連続退行判定の閾値にあと少しで到達しそうな接近
  状態を検知する
  `SpacedReviewBoxLevelRegressionStreakApproachingDetector`を
  weakモジュールに追加した（ApproachingDetectorパターン）。
- 保護者承認申請の連続却下判定の閾値にあと少しで到達しそうな接近
  状態を検知する
  `GuardianApprovalRequestRepeatedRejectionStreakApproachingDetector`を
  guardianモジュールに追加した（ApproachingDetectorパターン）。
- 弱点ノート復習の連続スキップ判定の閾値にあと少しで到達しそうな
  接近状態を検知する`WeakNoteReviewSkipStreakApproachingDetector`を
  weakモジュールに追加した（ApproachingDetectorパターン）。
- 推奨ダッキング音量への連続上書き判定の閾値にあと少しで到達し
  そうな接近状態を検知する
  `AudioCueVolumeDuckingOverrideStreakApproachingDetector`を
  audioモジュールに追加した（ApproachingDetectorパターン）。
- 見逃し猶予の連続利用判定の閾値にあと少しで到達しそうな接近状態
  を検知する`StreakRecoveryGraceRepeatedUsageApproachingDetector`を
  growthモジュールに追加した（ApproachingDetectorパターン）。
- プロフィール切替の誤操作連続発生判定の閾値にあと少しで到達し
  そうな接近状態を検知する`ProfileSwitchRevertStreakApproachingDetector`
  をprofileモジュールに追加した（ApproachingDetectorパターン）。
- 復習モード偏りアラートの連続無視判定の閾値にあと少しで到達し
  そうな接近状態を検知する
  `SessionReviewModeRatioAlertDismissalStreakApproachingDetector`を
  adaptiveモジュールに追加した（ApproachingDetectorパターン）。
- 難易度急変アラートの連続無視判定の閾値にあと少しで到達しそうな
  接近状態を検知する
  `QuestionDifficultyDriftAlertDismissalStreakApproachingDetector`を
  adaptiveモジュールに追加した（ApproachingDetectorパターン）。
- 週次レポート見直し提案の連続無視判定の閾値にあと少しで到達し
  そうな接近状態を検知する
  `WeeklyReportEngagementDeclineNoticeDismissalStreakApproachingDetector`
  をguardianモジュールに追加した（ApproachingDetectorパターン）。
- 代替通知手段案内の連続無視判定の閾値にあと少しで到達しそうな
  接近状態を検知する
  `GuardianDeliveryFailureAlternativeNoticeDismissalStreakApproachingDetector`
  をguardianモジュールに追加した（ApproachingDetectorパターン）。
- 通知積み上がりアラートの連続無視判定の閾値にあと少しで到達しそう
  な接近状態を検知する
  `GuardianNotificationBacklogSizeAlertDismissalStreakApproachingDetector`
  をguardianモジュールに追加した（ApproachingDetectorパターン）。
- コイン残高滞留通知の連続無視判定の閾値にあと少しで到達しそうな
  接近状態を検知する
  `CoinWalletStagnationNoticeDismissalStreakApproachingDetector`を
  growthモジュールに追加した（ApproachingDetectorパターン）。
- 設定バックアップ催促の連続無視判定の閾値にあと少しで到達しそうな
  接近状態を検知する
  `SettingsBackupStalenessNoticeDismissalStreakApproachingDetector`を
  privacyモジュールに追加した（ApproachingDetectorパターン）。
- 期限切れ事前通知の連続無視判定の閾値にあと少しで到達しそうな
  接近状態を検知する
  `InventoryItemExpiryNoticeDismissalStreakApproachingDetector`を
  growthモジュールに追加した（ApproachingDetectorパターン）。
- タイムゾーン再確認プロンプトの連続無視判定の閾値にあと少しで
  到達しそうな接近状態を検知する
  `TimeZoneDriftRecalibrationPromptDismissalStreakApproachingDetector`
  をregionalモジュールに追加した（ApproachingDetectorパターン）。
- 弱点ノート積み上がりアラートの連続無視判定の閾値にあと少しで
  到達しそうな接近状態を検知する
  `WeakNoteBacklogSizeAlertDismissalStreakApproachingDetector`を
  weakモジュールに追加した（ApproachingDetectorパターン）。
- 値下げ通知の連続無視判定の閾値にあと少しで到達しそうな接近状態
  を検知する`ItemPriceDropNoticeDismissalStreakApproachingDetector`
  をgrowthモジュールに追加した（ApproachingDetectorパターン）。
- プロフィール写真更新案内の連続無視判定の閾値にあと少しで到達
  しそうな接近状態を検知する
  `ProfilePhotoStalenessNoticeDismissalStreakApproachingDetector`を
  profileモジュールに追加した（ApproachingDetectorパターン）。
- 同期キュー滞留アラートの連続無視判定の閾値にあと少しで到達
  しそうな接近状態を検知する
  `SyncQueueBacklogAlertDismissalStreakApproachingDetector`を
  syncモジュールに追加した（ApproachingDetectorパターン）。
- ミュート解除確認提案の連続無視判定の閾値にあと少しで到達しそう
  な接近状態を検知する
  `AudioMuteStalenessNoticeDismissalStreakApproachingDetector`を
  audioモジュールに追加した（ApproachingDetectorパターン）。
- 再同意リマインドの連続無視判定の閾値にあと少しで到達しそうな
  接近状態を検知する
  `ConsentRenewalReminderDismissalStreakApproachingDetector`を
  privacyモジュールに追加した（ApproachingDetectorパターン）。
- 課金期限切れ事前通知の連続無視判定の閾値にあと少しで到達しそう
  な接近状態を検知する
  `EntitlementExpiryNoticeDismissalStreakApproachingDetector`を
  entitlementモジュールに追加した（ApproachingDetectorパターン）。
- 同期ペイロードサイズ異常アラートの連続無視判定の閾値にあと少し
  で到達しそうな接近状態を検知する
  `SyncPayloadSizeAlertDismissalStreakApproachingDetector`を
  syncモジュールに追加した（ApproachingDetectorパターン）。
- 同期完了案内の連続無視判定の閾値にあと少しで到達しそうな接近
  状態を検知する
  `OfflineSessionResumeNoticeDismissalStreakApproachingDetector`を
  syncモジュールに追加した（ApproachingDetectorパターン）。
- 弱点ノート急増アラートの連続無視判定の閾値にあと少しで到達しそ
  うな接近状態を検知する
  `WeakNoteBacklogGrowthRateAlertDismissalStreakApproachingDetector`
  をweakモジュールに追加した（ApproachingDetectorパターン）。
- 承認待ち滞留アラートの連続無視判定の閾値にあと少しで到達しそ
  うな接近状態を検知する
  `GuardianApprovalRequestBacklogSizeAlertDismissalStreakApproachingDetector`
  をguardianモジュールに追加した（ApproachingDetectorパターン）。
- 未適用マイグレーションアラートの連続無視判定の閾値にあと少しで
  到達しそうな接近状態を検知する
  `MigrationLedgerPendingMigrationAlertDismissalStreakApproachingDetector`
  をstoreモジュールに追加した（ApproachingDetectorパターン）。
- システム的同期障害アラートの連続無視判定の閾値にあと少しで到達
  しそうな接近状態を検知する
  `RetryBackoffExhaustionRateAlertDismissalStreakApproachingDetector`
  をsyncモジュールに追加した（ApproachingDetectorパターン）。
- 利用時間制限の頻繁な一時解除アラートの連続無視判定の閾値に
  あと少しで到達しそうな接近状態を検知する
  `ScreenTimeGuardOverrideFrequencyAlertDismissalStreakApproachingDetector`
  をguardianモジュールに追加した（ApproachingDetectorパターン）。
- 学習記録書き出しの再発行提案の連続無視判定の閾値にあと少しで
  到達しそうな接近状態を検知する
  `DataExportRenewalNoticeDismissalStreakApproachingDetector`を
  privacyモジュールに追加した（ApproachingDetectorパターン）。
- 購入復元プロンプトの連続無視判定の閾値にあと少しで到達しそう
  な接近状態を検知する
  `EntitlementRestorePromptDismissalStreakApproachingDetector`を
  entitlementモジュールに追加した（ApproachingDetectorパターン）。
- 承認待ちまとめ通知の連続無視判定の閾値にあと少しで到達しそう
  な接近状態を検知する
  `GuardianApprovalRequestBatchNoticeDismissalStreakApproachingDetector`
  をguardianモジュールに追加した（ApproachingDetectorパターン）。
- 猶予期間終了間近通知の連続無視判定の閾値にあと少しで到達しそう
  な接近状態を検知する
  `EntitlementGracePeriodEndingSoonReminderDismissalStreakApproachingDetector`
  をentitlementモジュールに追加した（ApproachingDetectorパターン）。
- 未使用アイテム種類数アラートの連続無視判定の閾値にあと少しで
  到達しそうな接近状態を検知する
  `InventoryItemUnusedVarietyAlertDismissalStreakApproachingDetector`
  をgrowthモジュールに追加した（ApproachingDetectorパターン）。
- 未使用アイテムの「使ってみよう」案内の連続無視判定の閾値にあと
  少しで到達しそうな接近状態を検知する
  `InventoryItemStaleUsageNoticeDismissalStreakApproachingDetector`
  をgrowthモジュールに追加した（ApproachingDetectorパターン）。
- 購入復元の長期未実行通知の連続無視判定の閾値にあと少しで到達
  しそうな接近状態を検知する
  `EntitlementRestoreStalenessNoticeDismissalStreakApproachingDetector`
  をentitlementモジュールに追加した（ApproachingDetectorパターン）。
- 却下後の再提出案内の連続無視判定の閾値にあと少しで到達しそう
  な接近状態を検知する
  `GuardianApprovalRequestStaleRejectionReminderDismissalStreakApproachingDetector`
  をguardianモジュールに追加した（ApproachingDetectorパターン）。
- 保護者ゲートのロック解除間近通知の連続無視判定の閾値にあと
  少しで到達しそうな接近状態を検知する
  `GuardianGateLockoutEndingSoonNoticeDismissalStreakApproachingDetector`
  をguardianモジュールに追加した（ApproachingDetectorパターン）。
- ロケール切替後のカリキュラム未読み込み通知の連続無視判定の
  閾値にあと少しで到達しそうな接近状態を検知する
  `LocaleCurriculumStalenessNoticeDismissalStreakApproachingDetector`
  をregionalモジュールに追加した（ApproachingDetectorパターン）。
- ストリークフリーズトークンの失効間近警告の連続無視判定の
  閾値にあと少しで到達しそうな接近状態を検知する
  `MissionStreakFreezeTokenExpiryWarningDismissalStreakApproachingDetector`
  をgrowthモジュールに追加した（ApproachingDetectorパターン）。
- ストリーク途切れ警告の連続無視判定の閾値にあと少しで到達しそうな
  接近状態を検知する`StreakRiskAlertDismissalStreakApproachingDetector`
  をgrowthモジュールに追加した（ApproachingDetectorパターン）。
- 誤解多様化アラートの連続無視判定の閾値にあと少しで到達しそうな
  接近状態を検知する`WeakNoteMisconceptionDiversityAlertDismissalStreakApproachingDetector`
  をweakモジュールに追加した（ApproachingDetectorパターン）。
- 写真利用同意再確認の連続無視判定の閾値にあと少しで到達しそうな
  接近状態を検知する`ProfilePhotoConsentRenewalDismissalStreakApproachingDetector`
  をprivacyモジュールに追加した（ApproachingDetectorパターン）。
- 間隔反復滞留アラートの連続無視判定の閾値にあと少しで到達しそうな
  接近状態を検知する`SpacedReviewOverdueBacklogAlertDismissalStreakApproachingDetector`
  をweakモジュールに追加した（ApproachingDetectorパターン）。
- 意欲低下通知の連続無視判定の閾値にあと少しで到達しそうな
  接近状態を検知する`UnitMasteryBadgeMotivationDropNoticeDismissalStreakApproachingDetector`
  をgrowthモジュールに追加した（ApproachingDetectorパターン）。
- 地域プロファイル読み込み失敗通知の連続無視判定の閾値にあと少しで
  到達しそうな接近状態を検知する`RegionalProfileLoadFailureFallbackNoticeDismissalStreakApproachingDetector`
  をregionalモジュールに追加した（ApproachingDetectorパターン）。
- 最古弱点ノート放置アラートの連続無視判定の閾値にあと少しで到達
  しそうな接近状態を検知する`WeakNoteBacklogOldestItemAgeAlertDismissalStreakApproachingDetector`
  をweakモジュールに追加した（ApproachingDetectorパターン）。
- 週次レポート連続未読放置状態が解消したかを検知する
  `WeeklyReportUnopenedStreakRecoveryDetector`をguardianモジュールに
  追加した（RecoveryDetectorパターン）。
- ストリークフリーズトークンの無駄遣い状態が解消したかを検知する
  `StreakFreezeTokenWasteRecoveryDetector`をgrowthモジュールに追加した
  （RecoveryDetectorパターン）。
- ガーディアンゲートの繰り返しロックアウト発生が解消したかを検知する
  `GuardianGateLockoutRepeatedTriggerRecoveryDetector`をguardianモジュール
  に追加した（RecoveryDetectorパターン）。
- 端末ロケール提案の連続無視状態が解消したかを検知する
  `DeviceLocaleSuggestionIgnoredRecoveryDetector`をregionalモジュール
  に追加した（RecoveryDetectorパターン）。
- 定着度減衰の悪化トレンドが解消したかを検知する
  `MasteryDecayAccelerationRecoveryDetector`をquestionモジュールに
  追加した（RecoveryDetectorパターン）。
- 週次レポートの連続流し見状態が解消したかを検知する
  `WeeklyReportSkimStreakRecoveryDetector`をguardianモジュールに
  追加した（RecoveryDetectorパターン）。
- 弱点ノート復習セッションの連続スキップ状態が解消したかを検知する
  `WeakNoteReviewSkipStreakRecoveryDetector`をweakモジュールに
  追加した（RecoveryDetectorパターン）。
- 猶予期間の繰り返し利用パターンが解消したかを検知する
  `EntitlementGracePeriodRepeatedUsageRecoveryDetector`をentitlement
  モジュールに追加した（RecoveryDetectorパターン）。
- アバター変更提案の連続無視状態が解消したかを検知する
  `ProfileAvatarRotationSuggestionIgnoredRecoveryDetector`をprofile
  モジュールに追加した（RecoveryDetectorパターン）。
- 推奨ダッキング音量の連続上書き状態が解消したかを検知する
  `AudioCueVolumeDuckingOverrideStreakRecoveryDetector`をaudio
  モジュールに追加した（RecoveryDetectorパターン）。
- 保護者承認申請の連続却下状態が解消したかを検知する
  `GuardianApprovalRequestRepeatedRejectionStreakRecoveryDetector`を
  guardianモジュールに追加した（RecoveryDetectorパターン）。
- 間隔反復箱レベルの連続退行状態が解消したかを検知する
  `SpacedReviewBoxLevelRegressionStreakRecoveryDetector`をweak
  モジュールに追加した（RecoveryDetectorパターン）。
