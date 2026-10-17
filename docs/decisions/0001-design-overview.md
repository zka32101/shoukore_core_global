# ADR 0001: shoukore_core_global の設計方針

- 日付: 2026-10-14
- 状態: 承認

## 背景

既存 `shared_core`（小学コレ！日本語版、7アプリ共通）の実装を検証した結果、以下の失敗パターンが確認された。
`shoukore_core_global` はこれらを踏まえ、既存 `shared_core` とは別物として新規設計する。

| # | shared_core の問題 | 本コアでの対策 |
|---|---|---|
| 1 | 手書き約148ファイル/3.45万行、範囲が膨張 | モジュールを7つに限定。社交系は作らない |
| 2 | l10n基盤なし、日本語直書き | 文字列は全てarb経由。直書きをlintでCI失敗させる |
| 3 | Firebase(auth/firestore/remote_config/messaging)を直接利用 | 抽象インターフェース越し。Firebase依存ゼロ |
| 4 | freezed生成物をコミット | freezed不使用。素のimmutableクラス |
| 5 | 価格・無料期間ロジックがキット内 | 課金はアプリ側。コアは`Entitlement`を読むだけ |
| 6 | `DateTime.now()`直書き | `Clock`を注入 |
| 7 | 教科が日本語ローマ字ID直書き | 教科/単元はカリキュラムJSONのID |
| 8 | 保護者ゲートの文言・数字表記が固定 | 文言はarb、数字表記もロケール対応 |
| 9 | DailyMission 5:00リセット固定、閾値がRemoteConfig依存 | 時刻/タイムゾーンは設定値、閾値はローカル既定＋差し替え可 |
| 10 | learning_metricsがFirestore JSONと密結合 | `ProgressStore`抽象 |
| 11 | テストがwidget1本＋rulesテストのみ | ロジックは単体テスト必須 |
| 12 | 単一squashコミット、`ref: main`参照 | タグ固定(`ref: vX.Y.Z`)、docs/decisionsをADR形式で |

## 方針

「言語・地域は"データ"、コードは中立」。ロケール差分は以下の3つに閉じ込める。

1. **文言**: `l10n/app_{ja,pt_BR,…}.arb`
2. **カリキュラム木**: `curriculum/{locale}.json`
3. **地域コンプラprofile**: `regional/{locale}.yaml`

## chukore_kit との関係

`chukore_kit`（ちゅうコレ！英語向け共通基盤）とはコードを共有しない。モデル設計の考え方
（素のimmutableクラス、Store抽象分離）のみ参考にし、本コアは完全新規実装とする
（2026-10-14 セッション内で確認・決定）。

## 結合確認（example/）での既知の留意点

`example/` のwidget結合テストで、複数の `testWidgets` に分けて毎回 `pumpWidget`
するとFlutter test環境のアセット読み込みが2回目以降で干渉し、`pumpAndSettle`が
ハングする現象を確認した。シナリオを1つの`testWidgets`に連結し、`pumpWidget`を
1回だけ呼ぶ構成で回避している。将来テストを増やす際もこの制約に注意する。

また、`ListView(children: [...])` は画面に収まらない項目をSliverの遅延構築で
materializeしないため、単元数が増えて一覧が画面高さを超えると、スクロールするまで
下部のWidget（保護者ゲートのタイル等）はElementツリーに存在しない。`find.text`等で
見つからない場合は例外が出ていなくても、まずスクロール不足を疑う
（`tester.scrollUntilVisible`で解決する）。

`ProgressStore`のdrift実装自体はコア側の単体テストで検証済みのため、
`example/`では`InMemoryProgressStore`（軽量実装）を使い、widget結合確認に専念している。

## LocalNotificationSchedulerのテスト範囲

`flutter_local_notifications`は実際の通知呼び出し（`zonedSchedule`/`cancel`等）が
プラットフォーム側のプラグイン登録（`FlutterLocalNotificationsPlatform.instance`、
Android/iOSのネイティブプラグイン登録メカニズム）に依存するため、CIのdart VM環境
（`flutter test`）では`LateInitializationError`になり検証できない。コア側の
単体テストはコンストラクタ・デフォルト値など純粋なロジック部分にとどめ、実際の
スケジューリング動作の結合確認は実機・エミュレータでのテストに委ねる。

## BNCCカリキュラム本格拡充（curriculum/pt_BR.json）と一次資料アクセスの制約

1º〜5º ano（anos iniciais）× 5 eixos（Números/Álgebra/Geometria/Grandezas e
medidas/Probabilidade e estatística）の計25単元に拡充した。このセッションからは
BNCC公式PDF（basenacionalcomum.mec.gov.br）・州教育局サイト・Nova Escola等の
一次資料に直接アクセスできず（名前解決の失敗またはプロキシの403）、Web検索の
要約で断片的に確認できた範囲のみを `Unit.verified: true` とし、それ以外は
`Unit.verified: false`（知識ベースの推測）としている。

- `verified: true`（Web検索で確認できたもの）: Números 1º-5º、Álgebra 1º-2º、
  Grandezas e medidas 1º・5º（体積の導入）、Probabilidade e estatística 1º-3º。
- `verified: false`（要検証・現地教員レビュー前提）: 上記以外すべて。特に
  Geometria（全学年）・Álgebra 3º-5ºはWeb検索で裏付けが取れていない。

### 第2回検証パス（2026-10-14、本セッション後半）

BNCC公式PDF・州教育局サイトへは引き続きアクセス不可（名前解決の失敗、または
プロキシのCONNECT拒否403）だったが、Web検索（WebSearchツール）経由で
Nova Escola・Tudo Sala de Aula・Profez等、複数の独立した教育系サイトが
一致する文言でhabilidadeを説明している単元について、以下を`verified: true`に
格上げした。いずれも官報PDFそのものの直接確認ではなく、複数の二次資料の
突き合わせによる確認であることに注意。

- `mat_numeros_4`（EF04MA01/06/07/08、4º ano乗除）: Nova EscolaとTudo Sala de
  Aulaが一致する文言を提示。
- `mat_numeros_5`（EF05MA01/07/08、5º ano数・加減乗除）: Tudo Sala de Aulaで
  3コードとも確認。ただしEF05MA07は厳密には加減算の habilidade であり、
  本単元が意図する除算は EF05MA08 が担う（コード自体の単元内訳は変更していない）。
- `mat_algebra_2`（EF02MA09/10/11、2º ano数列）: Tudo Sala de Aula・Nova
  Escola・Profezの3サイトで一致。

試みたが確認に至らなかったもの:
- `mat_geometria_2`（EF02MA14/15）: EF02MA15は「平面図形の認識・命名」、
  EF02MA14は「立体図形（円柱・立方体等）の認識」が本来の内容で、現行の
  `GeometryQuestionSource`（多角形の辺の数当て）とは一致度が低い。
  Geometria単元は本番投入前にテンプレート自体の作り直しが必要な可能性が高い。
- `mat_geometria_1`（EF01MA14）: Web検索でも文言を確認できず。
- `Unit.habilidadeCodes`（例: `EF01MA09`）はBNCCのhabilidadeコードとの対応を
  記録するためのフィールドで、出題ロジックからは参照しない。
- `tool/check_curriculum.dart` は各ファイルの `unverified` 単元数を出力する
  （CIは落とさない。現地教員レビューの優先度把握のため）。
- 出題テンプレートとhabilidadeの対応は粗い近似（例: Probabilidade
  e estatística 1º anoの本来の内容は「分類・確率の初歩」だが、既存の
  `StatisticsQuestionSource`（最大/最小/最頻値）で代用している）。本番投入前に
  現地教員によるカリキュラム・問題内容の作り直しが必須。

**推奨（次のアクション）**: ネットワーク制限のない環境でBNCC公式PDF
（`BNCC_EI_EF_110518_versaofinal_site.pdf`, Matemática anos iniciais,
p.276〜297付近）を取得し、`habilidadeCodes`と単元内容を機械的に照合すること。

## 週次レポート/弱点ノートのexample結合確認とQuestionCache

`WeeklyReportBuilder.build()`は`questionLookup`（questionId→Question）を要求するが、
`QuestionSource`は生成した問題を保持しないインターフェースのため、サンプルアプリ側に
`QuestionCache`（出題時に登録する簡易Map）を追加して結合確認に対応した。本番アプリでは
`ProgressStore`実装側（drift等）に問題スナップショット（misconceptionTags含む）を
永続化する設計にするのが望ましく、`QuestionCache`はあくまでexample用の簡易実装である。

## LGPD第14条・ECA Digital（Lei 15.211/2025）の法令確認状況

`regional/pt_BR.yaml`（`ageOfConsent: 12`, `guardianConsentRequired: true`,
`profilingAdsAllowed: false`）の既定値について、Web検索（複数の法律事務所・
ANPD関連の解説記事）で裏付けを確認した。公式法令原文（Planalto）には
ネットワーク制限で直接アクセスできていないため、以下はあくまで二次資料に
基づく暫定整理であり、**本番リリース前に現地弁護士の最終確認が必須**。

- **LGPD第14条**: 「crianças（ECA上12歳未満）」の個人データ処理は、両親または
  法定保護者の少なくとも1名による「特定かつ目立つ形の同意」（§1º）が必要、
  という理解は複数の法律解説サイトで一致しており、現行の`ageOfConsent: 12`
  `guardianConsentRequired: true`という既定と整合している。
  - 第2項: 収集するデータの種類・利用方法を公開する透明性義務あり
    （`exportUserData`で対応想定、文言化は未着手）。
  - 第3項: 保護者への連絡目的の一度限りの利用等、同意不要の例外あり。
  - ANPD Enunciado CD/ANPD nº 1/2023: 同意以外の法的根拠（第7条・第11条）も
    子ども・青少年データの処理根拠になり得るとされ、必ずしも「同意一択」では
    ないとの解説がある。本コアは同意ベースの設計（`ConsentStore`）のみを
    提供しており、他の法的根拠に基づく運用はアプリ側/事業者側の判断。
- **ECA Digital（Lei 15.211/2025）**: 2026年3月17日に施行されたとする解説記事が
  複数あり、海外企業にも適用範囲が及ぶ（アクセス地基準、事業者所在地は問わない）
  とされる。アプリのダウンロード時に保護者の明示的同意を要求する条文（第14条・
  第15条）が新設されたとの解説があるが、**この同意要件の対象年齢が「crianças
  （12歳未満）」限定か「menores（18歳未満の未成年全般）」まで及ぶのかは
  検索結果だけでは確定できなかった**。対象が18歳未満全般に及ぶ場合、現行の
  `ageOfConsent: 12`は「アプリ内データ取扱いの同意」には妥当でも、「アプリ
  ダウンロード自体の保護者同意」の要否判断には別の閾値が必要になる可能性がある。
  - ただし、アプリダウンロード時の年齢確認・保護者同意は主にOSストア
    （App Store/Google Play）側の年齢確認機構が担う部分が大きいと見られ、
    本コア（アプリ内の`ConsentStore`/`AgeGate`/`GuardianGate`）がカバーする
    範囲とは層が異なる可能性がある。この切り分けも含めて弁護士確認が必要。
  - 本コアの設計（Firebase非依存、同意同期なし、端末内保存）自体は
    ECA Digitalの要求を満たす上で不利にはならないと考えられるが、
    上記の不確実性から`regional/pt_BR.yaml`の数値は変更していない。

**次のアクション（未着手）**: 現地弁護士によるLGPD第14条・ECA Digital
（Lei 15.211/2025）の最終解釈確認。確認が取れ次第、`regional/pt_BR.yaml`の
コメントと必要なら`ageOfConsent`等の既定値を見直す。

## growthのexample結合確認とGrowthRepository

`DailyMissionRules`/`CoinWallet`/`GrowthStageCalculator`はいずれも永続化先を
規定しない純関数のみを提供するため、`weekly report`のQuestionCache同様、
サンプルアプリ側に`GrowthRepository`（端末内の簡易な状態保持、再起動で消える）
を追加して結合確認に対応した。本番アプリでは`ProgressStore`実装と同様に
永続化層を用意する必要がある。growth状態はロケール切替の影響を受けないため、
`RegionalProfile`（`DailyBoundary`の日付境界に使用）は初回ロード時のものを
保持し続け、ロケール切替のたびに作り直すことはしない。

## ProgressStore契約テスト

`ProgressStore`の実装（`DriftProgressStore`, `InMemoryProgressStore`）が同じ
契約を満たすことを保証するため、`test/progress_store_contract_test.dart`に
共通のテストスイート（`runProgressStoreContractTests`）を用意し、両実装に
対して実行する。従来は各実装ごとに別々のテストファイルで検証しており、
片方にだけ仕様変更が反映され契約が乖離するリスクがあった。新しい
`ProgressStore`実装を追加する際はこの関数を呼ぶテストを追加すること。

`InMemoryProgressStore`はこれまでサンプルアプリ(`example/`)内にのみ存在したが、
テスト・プロトタイピング用途や軽量アプリ向けの選択肢として、コア側
（`lib/src/progress/in_memory_progress_store.dart`）にも追加した。
`example/`側の実装はそのまま残している（example独自の初期化経路を保ちたいため）。

## 弱点ノート「克服」バッジのexample結合確認とmisconceptionTagsの実データ化

`WeakNotesAnalyzer.isOvercome()`はコア側の単体テスト（手組みのAttempt/Question
フィクスチャ）では検証済みだったが、本番のQuestionSource実装が実際に
`Question.misconceptionTags`を設定していなかったため、example側で意味のある
結合確認ができない状態だった。`ArithmeticQuestionSource`の減算に、典型的な
誤解（引き算を足し算と取り違える、`a + b`を誤答選択肢に含める）として
`subtraction_as_addition`タグを追加し、`example/`のQuestionScreenで
誤解傾向の分析→克服判定→バッジ表示（`misconceptionOvercomeBadge`）まで
一気通貫で動作することを確認できるようにした。

既存のGeometry/Measurement/Sequence/Statistics系QuestionSourceは引き続き
misconceptionTagsを設定していない（本格導入は別途の課題）。

既存の`example/test/integration_test.dart`の既定シナリオは加算単元
（`mat_numeros_1`）を使っており、減算の誤解克服フローは乱数に依存する
単元・テンプレ選択（`mat_numeros_2`はtpl_add/tpl_subをランダムに選択）のため、
決定的な結合テストシナリオの追加は見送った。コア側の単体テスト
（`subtraction_as_addition`タグの付与自体の検証）で確認している。

## ScreenTimeGuardのexample結合確認

`ScreenTimeGuard`は利用時間の計測自体をアプリ側に委ねる設計のため、
サンプルアプリでは出題画面を開いていた時間（`Clock`経由）を簡易に積算する
形で結合確認した。pt_BRの既定`screenTimeLimitMinutes`は0（無制限）のため、
結合確認用に「1分制限を模擬するトグル」（`screenTimeLimitToggleButton`）を
追加し、`RegionalProfile`を差し替えた`ScreenTimeGuard`で制限ありの挙動
（残り時間表示、超過時のロックメッセージ）を確認できるようにした。
実際に1分経過するのを待つテストは現実的でないため、結合テストでは
「トグルで残り時間表示が切り替わること」までを確認し、超過時の
ブロック挙動自体はコア側の単体テスト（`guardian_privacy_test.dart`）で
検証済みのロジックに委ねている。

## AgeGate/ConsentStoreのexample結合確認

`AgeGate`（生まれ年から保護者同意の要否を判定）と`ConsentStore`
（同意記録）はコア側に実装・単体テスト済みだったが、UI結合確認が
未着手だった（`consentTitle`等のarb文言も定義済みのまま未使用だった）。
`example/lib/age_gate_dialog.dart`に、生まれ年入力→`AgeGate`判定→
（必要なら）保護者同意ダイアログ→`ConsentStore.setConsent`、という
一連のフローを実装し、ホーム画面に同意状態を表示するタイルを追加した。
同意不要と判定された場合も`parentalConsentGiven: false`で記録し、
「未確認/不要」という表示上の区別は同意状態ではなく表示ロジック側で行う。

## NotificationScheduler/DailyReminderPlannerのexample結合確認

通知モジュール（`NotificationScheduler`/`DailyReminderPlanner`）はコア側に実装・
単体テスト済みだったが、UI結合確認が未着手だった。実機通知アダプタ
（`LocalNotificationScheduler`）はプラットフォームプラグイン登録に依存し
テスト環境では検証できないため（本章冒頭の方針通り）、サンプルアプリでは
`InMemoryNotificationScheduler`でスケジュール状態のUI結合確認に専念する。
ホーム画面に「デイリーミッションのリマインド通知」タイルを追加し、タップで
`DailyReminderPlanner.reminderAt()`が返す時刻への通知予約/解除を切り替えられる
ようにした。通知の実際のトリガー（OS側のスケジュール実行）自体はコア側の
単体テストと`LocalNotificationScheduler`の責務であり、ここではスケジュール
状態の表示のみを確認する。

## データ書き出し/削除・同意撤回のexample結合確認

`exportUserData`/`eraseAllUserData`（LGPD上の権利行使対応）と
`ConsentStore.revokeConsent`はコア側に実装・単体テスト済みだったが、UI結合確認が
未着手だった。保護者向けの`DataPrivacyScreen`をexampleに追加し、同意状態・
書き出し対象の学習記録件数の確認、保護者同意の撤回、確認ダイアログを経た
全データ削除を行えるようにした。実際のファイル保存・共有（`exportUserData`が
返す`Map`をJSON化してOSの共有シートに渡す等）はアプリ側の責務であり、ここでは
書き出し対象データの件数表示までを確認する。

## exportUserDataAsJsonの追加とexample結合確認

`exportUserData`が返す`Map`のJSON文字列化自体は教科・地域に依存しない共通処理
であるため、`exportUserDataAsJson`として本コアに追加した（実際のファイル保存・
共有UIは引き続きアプリ側の責務）。`example/`の`DataPrivacyScreen`に、書き出し
内容をJSON文字列としてクリップボードへコピーするボタンを追加し、結合確認した。
結合テストでは、`flutter_test`の既定バインディングに`Clipboard.setData`の
モックが無く呼び出しが応答なしにハングする問題があったため、
`integration_test.dart`の`main()`で`SystemChannels.platform`に対する
モックハンドラを登録している。また、SnackBarは実時間のタイマーで自動消去される
ため、`pumpAndSettle()`だけでは消えず、画面下部に残った不可視のオーバーレイが
後続のタップを吸収する問題があった。これを避けるため、SnackBar表示を確認した
直後に`tester.pump(const Duration(seconds: 5))`で消去を待ってから後続の操作を
行うようにした。

## 教科別アプリ/レポジトリ分割と本コアの境界

想定アーキテクチャは「教科ごとにアプリとレポジトリを分け、本コア
（`shoukore_core_global`）を共通ライブラリとして各アプリから利用する」
というものである。算数（Matemática）アプリはこのリポジトリの`example/`を
雛形に独立したレポジトリへ切り出す想定で、理科・国語など他教科のアプリも
同様に別レポジトリとして新設する。

この方針に基づき、本コアが抱えるべき責務と抱えるべきでない責務を以下の
ように線引きする。

- 本コアに残すもの（教科非依存）: `progress`/`adaptive`/`guardian`/
  `growth`/`notify`の各モジュール、`ProgressStore`/`ConsentStore`/
  `NotificationScheduler`等の抽象インターフェースとそのInMemory/drift/
  実機実装、`RegionalProfile`等の地域設定の読み込み基盤、`QuestionSource`
  インターフェース自体（教科を問わず出題を抽象化する契約）。
- 本コアから将来切り出すもの（教科固有）: `curriculum/pt_BR.json`等の
  算数カリキュラムJSONと、`ArithmeticQuestionSource`/
  `GeometryQuestionSource`/`MeasurementQuestionSource`/
  `SequenceQuestionSource`/`StatisticsQuestionSource`といった算数向け
  `QuestionSource`実装群。これらは「算数アプリ」のドメイン知識であり、
  理科や国語のアプリには不要などころか無関係である。

現時点ではこれらの算数固有コードは本コアに残したままである（`example/`が
算数アプリの雛形を兼ねているため）。算数アプリを独立レポジトリとして
新設するタイミングで、上記の教科固有コードをそのレポジトリ側へ移設し、
本コアからは削除する。移設の際は、`QuestionSource`インターフェース・
`Question`/`Unit`等のモデル型・`CurriculumRepository`が期待するJSON
スキーマ定義は本コア側の契約として残し、具体的なカリキュラムデータと
QuestionSource実装のみを移動する。

今後、本コアに新たな教科固有カリキュラム（理科・国語等）や教科固有の
`QuestionSource`実装を追加することはしない。新しい教科のアプリは、本コアの
抽象インターフェースを実装する形で独自レポジトリ側に実装する。

## GrowthStoreの追加とexample結合確認

growthモジュール（`DailyMissionRules`/`CoinWallet`/`GrowthStageCalculator`）は
純関数のみを提供し、`ProgressStore`/`ConsentStore`と異なり永続化先を規定する
抽象が存在しなかった。これにより、example側の`GrowthRepository`は端末内メモリ
保持（再起動で消える）に留まっていた。`ProgressStore`/`ConsentStore`と同様の
パターンで`GrowthStore`抽象（`GrowthSnapshot`の読み書き・`clearAll`）を追加し、
`InMemoryGrowthStore`と`DriftGrowthStore`（`progress.sqlite`内に`growth_states`
テーブルを追加、単一行保持）の2実装を用意した。両実装は
`test/growth_store_contract_test.dart`の契約テストで検証している。
example側の`GrowthRepository`は`GrowthStore`への保存・復元に書き換え、
`GrowthRepository.load()`で起動時に状態を読み込むようにした。他の
Storeモジュール同様、結合テストで検証しやすい`InMemoryGrowthStore`を使う。

## 新規ロケール追加の手順

本コアは地域ごとのコンプライアンス設定（`RegionalProfile`）を`regional/<locale>.yaml`
として、教科非依存の設定として保持する。一方、`curriculum/<locale>.json`は
算数固有のカリキュラムデータであり、「教科別アプリ/レポジトリ分割と本コアの境界」
の方針により、将来的には算数アプリ側のレポジトリへ移設する対象である。
新しいロケールを追加する際は、この2つを区別して進める。

本コアに追加するもの（教科非依存）:
1. `regional/<locale>.yaml`に、その地域の年齢同意・保護者同意要否・
   日次リセット時刻・タイムゾーン・利用時間制限・プロファイリング広告可否を
   定義する。対象国/地域の子ども向けプライバシー法令（LGPD/ECA Digital、
   COPPA等）を確認し、不確実な論点はADRに「法令確認状況」として残す
   （弁護士確認前提である旨を明記する）。
2. `test/curriculum_and_regional_test.dart`に、`parseRegionalProfile`で
   読み込めることを確認するテストを追加する。
3. `l10n/app_<locale>.arb`にUI文言を追加する（既存キー一式を翻訳する）。

本コアに追加しないもの（教科固有、アプリ側の責務）:
- `curriculum/<locale>.json`（算数カリキュラムデータ）
- 当該ロケール向けの`QuestionSource`実装の単元データ

今回、米国(en, COPPA)向けの`regional/en.yaml`を雛形として追加した。
`example/`側のロケール切替UIには追加していない（カリキュラムJSONが
無いロケールをexampleで選択可能にすると、該当教科のUIが破綻するため）。
実際にexampleで選択可能にするには、算数カリキュラムJSON
（`curriculum/en.json`）を別途用意する必要がある。

## 問題の解説(explanation)機能の有効化

`Question.explanationId`（教科書的な解説を指すキー）は初期設計から存在していたが、
カリキュラムJSONのテンプレに値が設定されず、exampleでも表示されない、未使用の
フィールドだった。`ArithmeticTemplate`（加減乗除）の各テンプレに演算の種類ごとの
`explanationId`（`explanation_add`/`explanation_subtract`/`explanation_multiply`/
`explanation_divide`）を設定し、example側に`resolveExplanation()`
（`explanationId`をarb文言へ解決するヘルパー）と、回答後に解説を表示するUIを
追加した。`explanationId`から実際の文言への解決はアプリ側（l10n）の責務とし、
本コアはIDのみを保持する設計を踏襲している。これにより「問題を解く機能」に加えて
「教科書のような解説を示す機能」が実際に動作するようになった。
他のQuestionSource（geometry/measurement/sequence/statistics）の各テンプレは
`explanationId`フィールド自体は既に持っているが、今回は未設定のままとした
（算数アプリ側で順次拡充する想定）。

## 学習ストリーク(LearningStreak)の追加

growthモジュールに「何日連続で学習したか」を計算する純関数`LearningStreak`を
追加した。`DailyMissionRules`等と同様、永続化やタイマー管理は持たず、
`recordStudy(now, boundary)`で次の状態を返すだけのimmutableな値オブジェクトと
した。同じミッション日内の2回目以降の学習はストリークを増やさず、前回の学習日の
翌ミッション日なら+1、それより間隔が空けば1にリセットする。
`GrowthSnapshot`/`GrowthStore`（drift実装は`growth_states`テーブルに
`currentStreakDays`/`lastStudiedDay`列を追加、schemaVersion 4へ移行）に
状態を持たせ、example側の`GrowthRepository.recordStudyActivity()`から
正誤を問わず全ての回答で更新するようにした（コイン・ミッション進捗は
正解時のみ更新する既存の`recordCorrectAnswer()`とは独立した経路）。

## ScreenTimeStoreの追加とexample結合確認

`ScreenTimeGuard`は利用時間の制限判定のみを行う純関数で、計測値の永続化先を
規定していなかった。これにより、example側は`_usedToday`という端末内メモリの
`Duration`フィールドに積算するだけで、再起動で消えるうえ日次リセットも
行われなかった（`DailyMissionRules`等とは異なり、日が変わっても
`_usedToday`がリセットされないバグが潜在していた）。`ProgressStore`/
`GrowthStore`と同様のパターンで`ScreenTimeStore`抽象
（`ScreenTimeSnapshot`の読み書き・`clearAll`）を追加し、
`InMemoryScreenTimeStore`と`DriftScreenTimeStore`（`progress.sqlite`内に
`screen_time_states`テーブルを追加、schemaVersion 5へ移行、単一行保持）の
2実装を用意した。example側に`ScreenTimeRepository`を追加し、
`ScreenTimeRepository.load()`/`addUsage()`でミッション日の変化を検知して
利用時間をリセットするように修正した。両実装は
`test/screen_time_store_contract_test.dart`の契約テストで検証している。

## SpacedReviewSchedulerの追加

誤答した問題を間隔反復（spaced repetition）で再提示するタイミングを計算する
純関数`SpacedReviewScheduler`を`weak`モジュールに追加した。`WeakNotesAnalyzer`
同様、永続化先は規定せず、Leitner方式（箱レベルが上がるほど復習間隔が広がり、
誤答すると箱レベル0に戻る）のロジックのみを提供する。`intervalsByBoxLevel`
（1/2/4/7/15日）はコンストラクタで差し替え不可の固定値とし、必要になれば
`AdaptiveDifficulty`のように閾値差し替え可能な設計へ拡張する。問題IDごとの
`ReviewState`の永続化・UIへの反映（復習リストの表示等）はアプリ側の責務であり、
本コアは「次にいつ復習すべきか」の計算のみを提供する。

## AchievementEvaluatorの追加

既存の`GrowthSnapshot`（ストリーク・累計正答数）から達成済みバッジを判定する
純関数`AchievementEvaluator`をgrowthモジュールに追加した。バッジ自体の
解除状態を保存する専用ストアは作らず、`GrowthStore`が既に保持している
`GrowthSnapshot`から毎回再計算する設計とした（`AdaptiveDifficulty`が
`Attempt`履歴から都度難易度を算出するのと同じ方針）。バッジの文言・アイコン
等はアプリ側のl10n/UIの責務とし、本コアは`AchievementId`（enum）と判定・
差分検出（`newlyUnlocked`）のロジックのみを提供する。

## ProfileStoreの追加（複数子どもプロファイル対応の土台）

1台の端末を複数の子どもで共有する家庭向けに、`ProfileStore`抽象
（`Profile`の一覧・選択状態の管理、`InMemoryProfileStore`/`DriftProfileStore`、
drift実装は`profiles`/`active_profile_state`テーブルを追加、schemaVersion 6へ
移行）を追加した。両実装は`test/profile_store_contract_test.dart`の契約テストで
検証している。

スコープを意図的に「プロファイルの一覧・選択状態の管理」のみに限定した。
`ProgressStore`/`GrowthStore`/`ScreenTimeStore`を実際にプロファイルIDで
分離する（単一行保持からプロファイルごとの複数行保持へ変更する等）のは
既存ストアすべてに影響する大きな変更であり、アプリ側が複数プロファイル
対応を必要とするタイミングで、本コアの各Store抽象に`profileId`引数を
追加する形で段階的に対応する想定とする（本PRでは未着手）。

## InventoryStore/InventoryManagerの追加

コインで購入できるアイテム（アバター装飾等）の所持状態を管理する
`InventoryStore`抽象（`InMemoryInventoryStore`/`DriftInventoryStore`、
drift実装は`owned_items`テーブル（1行=1所持アイテム）を追加、schemaVersion 7へ
移行）を追加した。購入可否判定・購入時の`CoinWallet`/`InventorySnapshot`の
状態遷移は純関数`InventoryManager`（`canPurchase`/`purchase`）が担い、
`CoinWallet.spend`が持つ残高不足時の例外をそのまま利用する設計とした。

アイテムの絵柄・説明文・価格設定（どのアイテムをいくつで売るか）は
教科と同様にアプリ側のドメイン知識とみなし、本コアの`StoreItem`は
`id`と`priceCoins`のみを持つ。これは「キット内の価格/無料期間ロジック」
（サブスクリプションの値付け、本コアが扱わない対象）とは異なり、
ゲーム内コインで買えるコスメティックアイテムの所持判定に限定した機能である。

## DailyDigestBuilderの追加

`WeeklyReportBuilder`と同じ入力（`ProgressStore`・単元IDリスト・`Clock`）を使い、
集計範囲を「今日1日分」に絞った`DailyDigestBuilder`/`DailyDigest`を追加した。
`WeeklyReportBuilder`が`answeredAt`を固定7日の`Duration`で絞るのに対し、
`DailyDigestBuilder`は`DailyBoundary.isSameMissionDay`で地域の日次リセット
時刻（`dailyResetHour`）を基準にした「今日」の判定を使う（`LearningStreak`/
`DailyMissionRules`と同じ基準）。`currentStreakDays`は`GrowthSnapshot`から
そのまま引き継ぐ。通知文言の組み立てと`NotificationScheduler`への実際の
スケジューリング（毎日決まった時間に送る、等）はアプリ側の責務とし、本コアは
要約データの集計のみを提供する。

## LocaleFormatterの追加（数字・日付表記のロケール対応）

「保護者ゲートの文言・数字表記が固定」（本ADR冒頭の表の8番）という既存の
課題に対応し、`package:intl`（`NumberFormat`/`DateFormat`）を薄くラップした
`LocaleFormatter`を`regional`モジュールに追加した。`RegionalProfile.locale`を
受け取り、桁区切り・日付・時刻のロケール対応表記を返す。文言そのもの（arb）は
引き続きアプリ側の責務であり、本コアが提供するのは数字・日付の表記ルールのみ。

`DateFormat`はロケールデータの初期化（`initializeDateFormatting(locale)`）に
依存するため、未初期化のロケールで呼ぶと`LocaleDataException`になる。
`flutter_localizations`経由でMaterialAppを構築している場合は通常自動的に
初期化されるが、コア側の単体テストでは明示的に
`package:intl/date_symbol_data_local.dart`の`initializeDateFormatting`を
呼ぶ必要がある（`test/locale_formatter_test.dart`参照）。

## PendingSyncQueueの追加（将来のサーバー同期に備えた土台）

本コアはFirebase等の外部サービスに依存しない方針（本ADR冒頭の表の3番）だが、
将来アプリ側が独自のサーバー同期機能を追加する可能性に備え、送信失敗した
アイテムを溜めて再送するキューの抽象`PendingSyncQueue`（`PendingSyncItem`の
enqueue/listPending/markSynced/markFailed/clearAll、`InMemoryPendingSyncQueue`/
`DriftPendingSyncQueue`、drift実装は`pending_sync_items`テーブルを追加、
schemaVersion 8へ移行）を`sync`モジュールに追加した。

`PendingSyncItem.payload`は`Map<String, dynamic>`（JSON互換の値のみ）とし、
drift実装では`jsonEncode`/`jsonDecode`で文字列化して保存する。実際の送信先
（HTTPエンドポイント等）・送信ロジック・リトライ間隔の制御はアプリ側の責務
であり、本コアは「送信待ちアイテムの永続化」「成功/失敗の記録」のみを提供する。
本コア自体は依然としてどのサーバーとも通信しない。

## ActiveProfileGuardの追加

「ProfileStoreの追加」で明記した通り、`ProgressStore`/`GrowthStore`/
`ScreenTimeStore`等はまだプロファイルIDで分離されていない。この制約の下で
プロファイル切替の事故（ある子どものデータ読み込み中に保護者が別の
子どものプロファイルに切り替え、古いデータを新プロファイルへ保存してしまう
等）を防ぐため、軽量な純関数`ActiveProfileGuard`（`isSameProfile`/
`ensureSameProfile`）を`profile`モジュールに追加した。

これは`Progress`/`Growth`/`ScreenTime`等のStoreに`profileId`を持たせる
本格的な対応の代替ではなく、アプリ側のRepository層が「データを読み込んだ
時点のプロファイルID」と「保存直前の現在のアクティブプロファイルID」を
比較し、不一致なら保存を中断する、という最小限の防御策である。

## SettingsBackupの追加（exportSettingsBackup/importSettingsBackup）

`exportUserData`/`exportUserDataAsJson`が学習記録（`Attempt`/`Mastery`）の
書き出しを担うのに対し、端末移行時に保護者が引き継ぎたい「設定」（同意状態・
プロファイル一覧・選択中プロファイルID）をまとめてバックアップ/復元する
`exportSettingsBackup`/`importSettingsBackup`（JSON文字列版の
`exportSettingsBackupAsJson`/`importSettingsBackupFromJson`含む）を
`privacy`モジュールに追加した。既存の`exportUserData`と役割を分け、
学習記録は対象外とした（将来、両者を1つにまとめて書き出す関数が必要になれば
アプリ側で合成する）。

`importSettingsBackup`は`ConsentStore.setConsent`/`ProfileStore.saveProfile`
の上書き挙動をそのまま使うため、既存の同意・プロファイル状態を上書きする。
実際のファイル保存・新端末への転送方法（クラウド経由、QRコード、ファイル
共有等）はアプリ側の責務であり、本コアはデータの組み立て・復元のみを提供する。

## AudioCuePlayerの追加

フィードバック音声・効果音（「よくできました」等）の再生要求を抽象化する
`AudioCuePlayer`（`InMemoryAudioCuePlayer`）を`audio`モジュールに追加した。
`NotificationScheduler`（実機通知の土台）と同じ方針で、本コアは`cueId`の
再生要求のみを定義し、実際の音声アセット（どのcueIdにどの音源を割り当てるか）
と再生エンジン（`audioplayers`等）はアプリ側の責務とする。`LocalNotificationScheduler`
のような実機アダプタは、必要になった時点で`shoukore_core_global_audio.dart`
等の別入口に追加する想定で、本PRでは未着手（テスト用の`InMemoryAudioCuePlayer`
のみ提供）。

## ReportReadStateの追加

`WeeklyReportBuilder`/`DailyDigestBuilder`が生成するレポートは都度計算する
純関数であり、「保護者が確認したかどうか」の状態を持たない。保護者向けUIで
未読バッジ（例: ホーム画面に「新しい週次レポートがあります」を表示する）を
実装できるようにするため、軽量な`ReportReadState`抽象
（`InMemoryReportReadState`/`DriftReportReadState`、drift実装は
`report_read_states`テーブルを追加、schemaVersion 9へ移行）を`guardian`
モジュールに追加した。`reportType`（`'weekly'`/`'daily'`等、アプリ側が決める
任意の文字列キー）ごとに最終既読時刻のみを保持し、レポートの内容・文言には
関与しない。

## MigrationLedgerの追加

drift自体のスキーマ移行（`MigrationStrategy.onUpgrade`、テーブルの追加・
カラムの追加等）とは別に、アプリ側のコード（Dartロジック）で行う一度きりの
移行処理（例: 旧シングルプロファイル時代のデータを`ProfileStore`の形式へ
移行する、旧バージョンの端末内ストレージ形式から新形式へデータを移す等）が
実行済みかどうかを記録する汎用台帳`MigrationLedger`（`InMemoryMigrationLedger`/
`DriftMigrationLedger`、drift実装は`applied_migrations`テーブルを追加、
schemaVersion 10へ移行。`ReportReadStates`追加のschemaVersion 9と競合した
ため、本マージでバージョン番号を調整した）を`store`モジュールに追加した。
`migrationId`はアプリ側が決める任意の文字列キーとし、本コアは実行済み
フラグの管理のみを提供する。実際の移行処理の実装（データ変換ロジック）は
アプリ側の責務。

## ExportChunkerの追加

`exportUserData`は`List<Mastery>`等を一度に`Map`へ組み立てて返す設計で、
学習記録が多い端末では出力全体を一度にメモリへ展開することになる。これに
備え、任意の`List<Map<String, dynamic>>`（`exportUserData`が返す`progress`
リスト等）を指定件数ごとに分割する純関数`ExportChunker`（`chunkByCount`/
`chunkToJson`）を`privacy`モジュールに追加した。各チャンクは
`{chunkIndex, chunkCount, items}`の形でJSON文字列化され、アプリ側で
ファイル分割保存・結合する際の単位として使える。`exportUserData`自体の
戻り値を変更するものではなく、必要なアプリが明示的に利用するユーティリティ
として提供する。

## GuardianGateLockoutの追加

`GuardianGate`（2桁×2桁の乗算チャレンジ）自体は再試行回数を制限しない設計
だったため、子どもが総当たりで正答を探すことを妨げない状態だった。これを
防ぐため、純関数`GuardianGateLockout`（`isLocked`/`recordFailure`/
`recordSuccess`）を`guardian`モジュールに追加した。`maxAttempts`回連続で
誤答すると`lockoutDuration`だけロックし、正答で状態をリセットする。状態
（`GuardianGateLockoutState`）の永続化先は規定せず、アプリ側が保持する
（画面を閉じればリセットされる想定でも、永続化したい場合は`GrowthStore`等
既存のパターンでアプリ側に追加する）。

## check_l10n_parity.dartの追加

`tool/check_curriculum.dart`と同様の方針で、`l10n/app_*.arb`間のキー整合性を
検証するCIツール`tool/check_l10n_parity.dart`を追加した。既存の
`tool/check_l10n.dart`（ARBの文言が直書きされていないか等を検証）とは別の
観点として、「新しいロケールを追加した際に、既存ロケールにあるキーが
翻訳漏れになっていないか」「使われなくなった古いロケールにキーが
余分に残っていないか」をCIで検出する。`@@locale`等の先頭`@`のメタキーは
比較対象から除外し、実際の文言キーのみを比較する。最初に見つかった
ファイル（ソート順で先頭）を基準とし、他の全ファイルと比較する。

## QuietHoursGuardの追加

`ScreenTimeGuard`は累積利用時間を制限するが、「夜21時〜朝7時のような特定の
時刻帯には使わせたくない」という保護者ニーズには対応できなかった。これを
補うため、純関数`QuietHoursGuard`（`isQuietAt`）を`guardian`モジュールに
追加した。`start`/`end`（`TimeOfDay`、日をまたぐ範囲も許容）を保護者が設定し、
`now`がその範囲内かを判定するだけで、新規ミッション開始の抑制や通知の
延期判断はアプリ側が行う。

## DeviceLocaleSuggesterの追加

初回起動時、OS側の端末ロケール（例: `pt_PT`）が本コアの対応ロケール
（`ja`/`pt_BR`/`en`）と完全一致しないことがある。これに対応するため、
純関数`DeviceLocaleSuggester`（`suggest`）を`regional`モジュールに追加した。
完全一致→言語コード一致→対応ロケール先頭（既定ロケール）の優先順位で
最も近いロケールを提案する。実際のOSロケール取得（`Platform.localeName`等）
はアプリ側の責務とする。

## ConsentExpiryPolicyの追加

`ConsentRecord`は同意済みかどうかの状態のみを持ち、「一定期間が過ぎたら
再同意が必要」「プライバシーポリシー改定後は再同意が必要」といった運用を
本コアでは支援していなかった。これに対応するため、純関数
`ConsentExpiryPolicy`（`isExpired`/`needsReconfirmation`）を`privacy`
モジュールに追加した。`validity`（有効期間）と`currentPolicyVersion`
（現行ポリシーバージョン）を設定値として受け取り、`ConsentRecord`の
`consentedAt`/`policyVersion`と比較するだけで、`ConsentStore`への保存・
読込自体には関与しない。

## RetryBackoffPolicyの追加

`PendingSyncQueue`は失敗回数（`retryCount`）を保持するが、「次にいつ
再送してよいか」の計算は本コアでは支援していなかった。これに対応するため、
純関数`RetryBackoffPolicy`（`nextDelay`/`shouldRetryNow`/
`hasExhaustedRetries`）を`sync`モジュールに追加した。`baseDelay * 2^retryCount`
を`maxDelay`で上限、`maxAttempts`到達後は再送を諦めるべきと判定する。
実際のHTTP送信・APIコールはアプリ側の責務とする。

## StaleDataPolicyの追加

オフライン運用が長期化した端末では、ローカルの`ProgressStore`/`GrowthStore`
等がサーバーと長期間同期されないままになる可能性がある。これを検知するため、
純関数`StaleDataPolicy`（`isStale`/`remainingUntilStale`）を`sync`モジュールに
追加した。`lastSyncedAt`（最終同期時刻、未同期は`null`）と`now`を受け取り、
`staleAfter`を超えていれば要同期と判定するだけで、最終同期時刻の記録・保存
自体はアプリ側の責務とする。

## UnitRecommendationの追加

出題画面から「次にやる単元」への導線を作る際、未学習・弱点が強い単元を
優先して提案するロジックが各アプリでバラバラに実装されることを避けるため、
純関数`UnitRecommendation`（`recommend`/`topPick`）を`question`モジュールに
追加した。候補の`unitId`一覧と`Mastery`マップを受け取り、`score`が低い
（未学習は`score: 0`扱い）単元ほど優先する順序を返すだけで、カリキュラムの
単元順序や`Entitlement`（解禁状態）は関与しない。

## SessionTimeoutPolicyの追加

共有端末では、保護者がゲートを通過した後、子どもが放置した端末を
別の家族がそのまま使い続けてしまう可能性がある。これに対応するため、
純関数`SessionTimeoutPolicy`（`shouldLock`/`remainingUntilLock`）を
`guardian`モジュールに追加した。最後の操作時刻（`lastInteractionAt`）から
一定時間（`timeout`）を超えたらロック状態に戻すべきと判定するだけで、
実際のロック画面表示・入力監視・`GuardianGate`との連携はアプリ側の責務
とする。

## MasteryDecayの追加

`Mastery.score`はそれまでの正答率を反映するが、長期間学習していない単元も
過去のスコアをそのまま維持してしまい、「しばらくやらないと忘れる」という
実態を反映できなかった。これに対応するため、純関数`MasteryDecay`
（`decayedScore`）を`question`モジュールに追加した。`lastPracticedAt`から
`gracePeriod`を超えた分だけ`halfLife`（半減期）で指数的にスコアを減衰させる。
`ProgressStore`への保存は行わず、`UnitRecommendation`等の入力として使う
表示・判定用の値を計算するだけで、永続化された`Mastery`自体は書き換えない。

## ExportIntegrityCheckerの追加

端末移行時に`exportUserData`/`exportUserDataAsJson`で書き出したデータを
別端末へ再取り込みする場面で、壊れたファイルや別バージョン・別形式の
データを誤って取り込むリスクがある。これに対応するため、純関数
`ExportIntegrityChecker`（`validate`/`isValid`）を`privacy`モジュールに
追加した。`exportUserData`の出力構造（`consent`/`progress`の各キーと型）
を検証するだけで、実際のファイル読み込み・インポート処理自体はアプリ側の
責務とする。

## ProfileSwitchCooldownの追加

兄弟で1台の端末を共有する際、「本当にコインが貯まったか」を確認したい
子ども同士が短時間にプロファイルを連打切替してしまい、画面がちらつく
だけでなく誤操作の温床にもなる。これに対応するため、純関数
`ProfileSwitchCooldown`（`canSwitch`/`recordSwitch`）を`profile`モジュールに
追加した。最後に切り替えた時刻から`cooldown`を超えるまでは次の切替を
許可しないと判定するだけで、`ActiveProfileGuard`（切替中のデータ混在防止）
とは独立しており、実際の切替UI・ブロック表示はアプリ側の責務とする。

## CoinSpendingLimitの追加

`InventoryManager`は残高と所持状況のみで購入可否を判定し、「1日に使い
すぎていないか」という保護者視点の制限には対応していなかった。これに
対応するため、純関数`CoinSpendingLimit`（`wouldExceedLimit`/
`recordSpending`）を`growth`モジュールに追加した。`CoinSpendingState`
（当日消費済みコイン数）と`dailyLimit`を比較するだけで、日替わりの
判定・リセット自体は既存の`DailyBoundary`と組み合わせてアプリ側が行う。

## NotificationQuietMergeの追加

`QuietHoursGuard`は「今が静かな時間帯かどうか」を判定するだけで、
「静かな時間帯に予定されていた通知をいつに動かすべきか」までは計算
していなかった。これに対応するため、純関数`NotificationQuietMerge`
（`resolve`）を`notify`モジュールに追加した。`QuietHoursGuard`を受け取り、
`scheduledAt`が静かな時間帯に含まれる場合はその時間帯が明ける時刻
（`guard.end`、日をまたぐ範囲も考慮）を返すだけで、実際の再スケジュール
処理（`NotificationScheduler`への再登録）はアプリ側の責務とする。

## AnswerStreakBonusの追加

連続正解に対するボーナスコイン付与ロジックが各アプリでバラバラに
実装されることを避けるため、純関数`AnswerStreakBonus`（`bonusFor`）を
`growth`モジュールに追加した。回答1回ごとの連続正解数（`LearningStreak`
の学習日連続とは別物）を受け取り、`interval`回ごとに`bonusPerInterval`
コインを返すだけで、`CoinWallet.earn`への実際の反映はアプリ側が行う。

## ConsentAuditLogの追加

`ConsentStore`は現在の同意状態のみを保持し、「いつ付与・撤回・ポリシー
更新があったか」という履歴を遡れなかった。保護者がLGPD等の文脈で過去の
同意履歴を確認したい場合に備え、純関数`ConsentAuditLog`（`append`）と
値オブジェクト`ConsentAuditEntry`を`privacy`モジュールに追加した。
`append`は履歴に新しいエントリを追加し、`maxAge`を超えた履歴を削除した
上で`maxEntries`を超える分を古いものから削除するだけで、履歴自体の
永続化はアプリ側の責務とする。

## TimeZoneDriftDetectorの追加

海外旅行やOSのタイムゾーン設定変更があると、`DailyBoundary`が前提とする
「1日の境界」判定が端末ごとに食い違い、学習記録の日付集計やストリーク
判定がおかしくなる可能性がある。これを検知する手がかりとして、純関数
`TimeZoneDriftDetector`（`hasDrifted`）を`regional`モジュールに追加した。
前回記録したタイムゾーン識別子と現在のものを比較するだけで、実際の
タイムゾーン取得・記録の永続化・変更時の対応（再確認ダイアログ等）は
アプリ側の責務とする。

## ReviewSessionPacerの追加

長時間連続で問題を解き続けると、集中力低下や目の疲労につながるため、
純関数`ReviewSessionPacer`（`shouldSuggestBreak`）を`guardian`モジュールに
追加した。セッション開始からの連続解答数または経過時間のいずれかが
閾値を超えた場合に休憩を提案すべきと判定するだけで、`SessionTimeoutPolicy`
（無操作時のロック）とは独立した概念である。実際の休憩提案UI・
タイマー管理はアプリ側の責務とする。

## AchievementShareCardDataの追加

保護者が子の達成バッジを共有したくなる場面向けに、純関数
`AchievementShareCardBuilder`（`build`）を`growth`モジュールに追加した。
`AchievementId`からランク（`AchievementRank`: bronze/silver/gold）と
獲得日時をまとめた`AchievementShareCardData`を組み立てるだけで、
タイトル・説明文言は`AchievementId`同様アプリ側のl10nで解決する想定。
画像生成・SNS連携などの実際の共有処理はアプリ側の責務とする。

## ProfileAvatarRotationSuggesterの追加

キャラ進化（`GrowthStage`の変化）に合わせてアバター変更を促したい場面向けに、
純関数`ProfileAvatarRotationSuggester`（`shouldSuggestRotation`）を`profile`
モジュールに追加した。前回アバター変更を提案した時点の進化段階と現在の
進化段階を比較するだけで、まだ一度も提案していない（`previousStage`が
`null`）場合は提案しない。実際のアバター選択UI・保存・候補一覧の管理は
アプリ側の責務とする。

## WeakNotesReviewSchedulerの追加

`WeakNotesAnalyzer`が特定した弱点単元を優先的に復習させたい場面向けに、
純関数`WeakNotesReviewScheduler`（`schedule`、`dueUnitIds`）を`weak`モジュール
に追加した。`SpacedReview`（問題単位のLeitner式間隔反復）とは別に、単元
単位で誤解の総回数が多いほど復習間隔を短くするだけの優先度付けであり、
実際の復習問題の選定・提示はアプリ側の責務とする。

## GuardianDigestMuteWindowの追加

保護者が一定期間（旅行中など）ダイジェスト通知を止めたい場面向けに、
純関数`GuardianDigestMuteWindow`（`isMutedAt`）を`guardian`モジュールに
追加した。`QuietHoursGuard`（子供側の毎日の静かな時間帯）とは異なり、
保護者が指定した`mutedUntil`までの任意の期間をミュート中と判定するだけで、
実際の通知停止処理・設定UIはアプリ側の責務とする。

## EntitlementGracePeriodの追加

オフライン環境で課金ストアへの再確認ができないまま失効扱いになる体験
悪化を避けるため、純関数`EntitlementGracePeriod`（`isWithinGrace`、
`graceEndsAt`）を`entitlement`モジュールに追加した。失効時刻から一定期間
内であれば引き続き利用可能とみなすだけで、価格・プラン自体のロジックは
`EntitlementReader`（アプリ側のRevenueCat等実装）の責務のまま変わらない。

## GuardianApprovalRequestQueueの追加

子がコイン使用やストア購入を試みた際、保護者が後から確認・承認/却下する
非同期フロー向けに、純関数`GuardianApprovalRequestQueue`（`isExpired`、
`pendingRequests`）と値オブジェクト`GuardianApprovalRequest`を`guardian`
モジュールに追加した。`GuardianGate`（即時PINによる計算チャレンジ）とは
異なり、承認待ちのまま一定期間が過ぎたら期限切れと判定するだけで、
申請の永続化・実際の通知送信はアプリ側の責務とする。

## UnitMasteryBadgeEligibilityの追加

単元単位で「マスター」バッジを付与したい場面向けに、純関数
`UnitMasteryBadgeEligibility`（`isMastered`）を`growth`モジュールに追加した。
`Achievement`（ストリーク・累計正答数という教科非依存の全体指標）とは別に、
単元ごとの直近N件の正答率が閾値以上かを判定するだけで、バッジの永続化・
通知表示はアプリ側の責務とする。

## OfflineSyncConflictResolverの追加

オフライン中に複数端末で記録された進捗データが同期時に競合する場合に
備え、純関数`OfflineSyncConflictResolver`（`resolve`）と値オブジェクト
`SyncableRecord`を`sync`モジュールに追加した。`updatedAt`が新しい方を
採用する単純なlast-write-winsのみを行い、同時刻の場合はサーバー側
（remote）を優先する。実際のマージ処理・サーバーAPIの呼び出しは
アプリ側の責務とする。

## CoinEarningCapPerDayの追加

過剰な繰り返し操作によるコインのインフレを防ぐため、純関数
`CoinEarningCapPerDay`（`wouldExceedCap`、`recordEarning`）と値オブジェクト
`CoinEarningState`を`growth`モジュールに追加した。`CoinSpendingLimit`
（使用側の1日あたり上限）と対になる獲得側の上限で、設計も同様に
「1日」の境界判定自体はアプリ側が`DailyBoundary`を使って行い、本クラスは
単純な加算・上限比較のみを担う。

## ProfilePhotoConsentGateの追加

アバター用のカメラ撮影・画像選択は端末のカメラロール等へのアクセスを
伴うため、純関数`ProfilePhotoConsentGate`（`requiresConsent`）と値オブジェクト
`ProfilePhotoConsent`を`privacy`モジュールに追加した。`ConsentRecord`
（保護者同意・年齢確認の全体記録）とは別の、写真利用という目的特化の
最小限の同意判定のみを行い、実際の同意取得UI・画像の保存/削除処理は
アプリ側の責務とする。

## StreakRecoveryGraceの追加

1日学習を忘れただけでストリークが完全にリセットされるとモチベーションを
損ねるため、純関数`StreakRecoveryGrace`（`isRecoverable`）を`growth`
モジュールに追加した。`LearningStreak.recordStudy`自体の厳密な連続判定
ロジックは変更せず、間隔が[graceDays]日以内の見逃しであれば継続扱いに
してよいと判定するだけで、実際にストリークを復元する処理（`LearningStreak`
の再構築、復元の演出・通知等）はアプリ側の責務とする。

## RegionalHolidayMissionSkipの追加

地域の祝日・休校日には`DailyMission`の未達成を強制したくない場面向けに、
純関数`RegionalHolidayMissionSkip`（`isSkippable`）を`growth`モジュールに
追加した。祝日データ自体の取得・保持は`RegionalProfile`に持たせず、
アプリ側が渡す祝日一覧（ミッション日単位の日付集合）と照合するだけの
軽量な手がかりとし、実際のミッション未達成時の扱い（通知抑制、UI表示等）
はアプリ側の責務とする。

## SiblingProfileSwitchSuggestionの追加

同じ端末を兄弟間で共有している場合、使い終わったら自然にプロフィール
切替を促したい場面向けに、純関数`SiblingProfileSwitchSuggestion`
（`shouldSuggestSwitch`）を`profile`モジュールに追加した。
`ProfileSwitchCooldown`（切替直後の連続切替を制限する）とは逆方向の、
一定時間の無操作を手がかりに切替を促すロジックであり、実際の提案UI・
切替処理はアプリ側の責務とする。

## QuestionDifficultyDriftAlertの追加

`AdaptiveDifficulty`が算出する難易度が短期間に大きく変動した場合、
不正操作や極端な得点パターンの手がかりとなるよう、純関数
`QuestionDifficultyDriftAlert`（`isDrifting`）を`adaptive`モジュールに
追加した。前後の難易度の変化量が閾値以上かを判定するだけで、
`AdaptiveDifficulty`自体の難易度調整ロジックは変更せず、実際のアラート
対応（通知・保護者への報告等）はアプリ側の責務とする。

## ScreenTimeWarningThresholdの追加

利用時間制限に達する直前に子どもへ警告を出したい場面向けに、純関数
`ScreenTimeWarningThreshold`（`shouldWarn`）を`guardian`モジュールに
追加した。`ScreenTimeGuard`（制限超過自体の判定）に委ね、残り時間の
割合が閾値以下になったかを見るだけで、既に制限超過の場合は対象外とする。
実際の警告UI・通知の表示はアプリ側の責務とする。

## DataExportRequestThrottleの追加

データ書き出し要求（`exportUserData`、LGPD第18条等の権利行使対応）が
短期間に繰り返されるのを防ぐため、純関数`DataExportRequestThrottle`
（`shouldThrottle`、`nextAllowedAt`）を`privacy`モジュールに追加した。
直前の要求時刻からの間隔が最小間隔未満かを判定するだけで、実際の
書き出し処理の呼び出し制御・UI表示はアプリ側の責務とする。

## GuardianPinRotationReminderの追加

保護者ゲートの認証情報を長期間変更していない場合にローテーションを
促したい場面向けに、純関数`GuardianPinRotationReminder`
（`shouldRemind`）を`guardian`モジュールに追加した。`GuardianGate`自体の
認証ロジックは変更せず、最終変更時刻からの経過日数が閾値以上かを
判定するだけで、実際のローテーション促進UI・変更フローはアプリ側の
責務とする。

## ItemPriceDropNoticeの追加

ストアアイテムの価格が下がった際にお得感を伝えたい場面向けに、純関数
`ItemPriceDropNotice`（`shouldNotify`）と値オブジェクト`SeenItemPrice`を
`growth`モジュールに追加した。前回記録した価格との単純比較のみを行い、
`InventoryManager`の購入判定には関与しない。価格自体の決定・セール運用
ロジックはアプリ側の責務とする。

## InventoryDuplicateGiftGuardの追加

キャンペーン等の購入を伴わないギフト付与経路でも重複付与を防ぎたい
場面向けに、純関数`InventoryDuplicateGiftGuard`（`shouldBlockGift`）を
`growth`モジュールに追加した。`InventoryManager`（コイン購入経路の
重複チェック）と同じ考え方を別経路にも適用するだけで、実際のギフト
付与処理・付与結果の通知はアプリ側の責務とする。

## SyncQueueBacklogAlertの追加

`PendingSyncQueue`に未送信アイテムが溜まり続けている場合に同期不調を
検知したい場面向けに、純関数`SyncQueueBacklogAlert`（`shouldAlert`）を
`sync`モジュールに追加した。`RetryBackoffPolicy`（個々のアイテムの再送
タイミング）とは別に、キュー全体の件数が閾値以上かを見るだけで、実際の
アラート表示・ユーザーへの通知はアプリ側の責務とする。

## MissionStreakFreezeTokenの追加

ストリークが途切れそうな日にアイテム等で保護したい場面向けに、純関数
`MissionStreakFreezeToken`（`shouldConsumeToken`）を`growth`モジュールに
追加した。`StreakRecoveryGrace`（学習自体による見逃し猶予）とは異なる、
トークン消費による保護経路を扱う。実際のトークン所持数の管理・付与・
消費演出はアプリ側の責務とする。

## GuardianNotificationDigestThrottleの追加

保護者向け通知が短時間に連続して送られすぎないようにしたい場面向けに、
純関数`GuardianNotificationDigestThrottle`（`shouldThrottle`）を
`guardian`モジュールに追加した。`GuardianDigestMuteWindow`（保護者が
指定するミュート期間）とは異なり、直前の送信時刻からの経過時間のみで
判定する。実際の通知のまとめ・送信処理はアプリ側の責務とする。

## AnswerLatencyOutlierFlagの追加

解答にかかった時間が極端に短い、または長い場合に異常値として検知したい
場面向けに、純関数`AnswerLatencyOutlierFlag`（`isOutlier`）を`adaptive`
モジュールに追加した。`QuestionDifficultyDriftAlert`（難易度の変動検知）
とは異なり、個々の解答の所要時間のみを見るだけで、実際の異常値への対応
（アラート・保護者への報告等）はアプリ側の責務とする。

## ConsentRenewalReminderの追加

保護者同意の有効期限が切れる前に再同意を促したい場面向けに、純関数
`ConsentRenewalReminder`（`shouldRemind`）を`privacy`モジュールに追加した。
`ConsentExpiryPolicy`（既に期限切れ/再同意必須かどうかの判定）とは異なり、
期限切れ前の事前リードタイムのみを扱う。実際のリマインド表示・送信処理は
アプリ側の責務とする。

## GrowthStageRegressionGuardの追加

`GrowthStageCalculator`が算出した新しい成長段階が保存済みより後退して
いないかを検知したい場面向けに、純関数`GrowthStageRegressionGuard`
（`isRegression`）を`growth`モジュールに追加した。進化段階は単調に進む
べきもので、データ不整合等による後退をキャラ更新前に検知するだけで、
実際の不整合発生時の対応（データ再計算・ログ送信等）はアプリ側の責務
とする。

## OfflineSessionGapDetectorの追加

アプリの前回終了から今回起動までの間隔が長時間だった場合に復帰時の
演出・案内を出したい場面向けに、純関数`OfflineSessionGapDetector`
（`isLongGap`）を`sync`モジュールに追加した。`StaleDataPolicy`
（サーバーとの最終同期からの経過による要同期判定）とは異なり、ローカルな
起動間隔のみを見る。実際の復帰時UI・再同期のトリガーはアプリ側の責務
とする。

## PhotoConsentExpiryCascadeの追加

プロフィール写真利用の同意が失効した際、既に保存済みの写真そのものも
削除対象にすべきかを判定したい場面向けに、純関数
`PhotoConsentExpiryCascade`（`shouldDeleteStoredPhoto`）を`privacy`
モジュールに追加した。`ProfilePhotoConsentGate`（新規利用前の同意確認）
とは異なり、同意取り消し後に写真が残り続けることを防ぐための事後判定を
扱う。実際の写真削除処理はアプリ側の責務とする。

## MissionSkipStreakCapの追加

`RegionalHolidayMissionSkip`等によるミッション未達成の見逃しが連続
しすぎた場合に、ストリーク継続扱いの対象外にしたい場面向けに、純関数
`MissionSkipStreakCap`（`exceedsCap`）を`growth`モジュールに追加した。
見逃しの連続日数が上限を超えたかを見るだけで、実際のストリーク更新
処理自体はアプリ側の責務とする。

## GuardianApprovalRequestReminderEscalationの追加

保護者承認申請が期限切れになる前に、未処理のままであることをリマインド
したい場面向けに、純関数`GuardianApprovalRequestReminderEscalation`
（`shouldEscalate`）を`guardian`モジュールに追加した。
`GuardianApprovalRequestQueue.isExpired`（既に期限切れかどうかの判定）
とは異なり、期限切れ前の事前リードタイムのみを扱う。実際のリマインド
表示・通知送信はアプリ側の責務とする。

## WeakNoteStalenessCleanupの追加

`WeakNote`が長期間更新されず放置され続けた場合、整理（アーカイブ・
非表示化）対象にしたい場面向けに、純関数`WeakNoteStalenessCleanup`
（`shouldCleanUp`）を`weak`モジュールに追加した。
`WeakNotesReviewScheduler`（復習タイミングの計算）とは異なり、復習
されずに古くなったノートの掃除を扱う。実際のアーカイブ・削除処理は
アプリ側の責務とする。

## EntitlementRestorePromptの追加

再インストール等で以前購入していた教科アンロックが`EntitlementReader`
の結果に反映されていない場合に、購入の復元（リストア）を促したい場面
向けに、純関数`EntitlementRestorePrompt`（`shouldPromptRestore`）を
`entitlement`モジュールに追加した。`EntitlementGracePeriod`（失効直後の
継続利用猶予）とは異なり、ローカルに記録済みの以前の権利情報と現在の
権利情報のずれを検知する。実際のリストア処理・UI表示はアプリ側の責務
とする。

## AudioCueVolumeDuckingSuggestionの追加

BGM再生中に効果音（`AudioCuePlayer`）を鳴らす際、BGM音量を一時的に
下げたい場面向けに、純関数`AudioCueVolumeDuckingSuggestion`
（`shouldDuck`・`duckedVolumeFor`）を`audio`モジュールに追加した。
`AudioCuePlayer`自体は再生のみを担うため、音量ミキシングの単純な比率
計算のみを行う。実際の音量制御・フェード処理はアプリ側の責務とする。

## ProfileSwitchAuditLogの追加

保護者が後から「いつ・どのプロフィールに切り替わったか」を確認できる
ようにしたい場面向けに、プロフィール切り替えの発生を記録すべきかを
判定する`ProfileSwitchAuditLog`を`profile`モジュールに追加した。
`ActiveProfileGuard`（保存直前の不整合検知）とは異なり、正常な切り替え
操作そのものを記録対象にするかどうかを判定するだけで、実際の記録の
保存・一覧表示はアプリ側の責務とする。

## CoinWalletOverdraftGuardの追加

購入ボタンの有効/無効切り替え等、コイン残高不足を例外を伴わずに事前
確認したい場面向けに、`CoinWalletOverdraftGuard`を`growth`モジュールに
追加した。`CoinWallet.spend`は残高不足時に`StateError`を投げる設計の
ため、例外を使わずに判定したい用途向けに分離した。実際の購入UI・
エラー表示はアプリ側の責務とする。

## TimeZoneDriftRecalibrationPromptの追加

タイムゾーン変更の検知（`TimeZoneDriftDetector`）が単発の一時的な
ブレではなく継続して観測された場合にのみ、ミッション日境界の再確認を
促したい場面向けに、`TimeZoneDriftRecalibrationPrompt`を`regional`
モジュールに追加した。起動ごとの揺れ（機内モード中の一時的な誤検知
等）で毎回促してしまわないよう、連続観測回数で判断する。実際の再確認
ダイアログ表示はアプリ側の責務とする。

## DailyDigestDuplicateSuppressionの追加

`DailyDigestBuilder`で組み立てた日次要約を同じミッション日内に複数回
送信してしまわないよう抑制したい場面向けに、
`DailyDigestDuplicateSuppression`を`guardian`モジュールに追加した。
`DailyDigestBuilder`自体は要約の組み立てのみを担い送信済み管理には
関与しないため、本クラスが最後に送信したミッション日との比較を行う。
実際の送信済み記録の保存・送信処理はアプリ側の責務とする。

## MigrationLedgerRollbackGuardの追加

`MigrationLedger`に「適用済み」と記録されているマイグレーションIDの中に
現在のアプリが知らないものが含まれていないか（アプリのダウングレード等
で生じ得る異常）を検知したい場面向けに、`MigrationLedgerRollbackGuard`を
`store`モジュールに追加した。`MigrationLedger`自体は適用済みかどうかの
記録・問い合わせのみを担うため、本クラスが現在のアプリが認識している
マイグレーションID一覧との差分を見る。実際の警告表示・データ整合性の
復旧処理はアプリ側の責務とする。

## QuestionVarietyBiasDetectorの追加

直近の出題履歴が同じ単元・タグに偏りすぎていないかを検知したい場面
向けに、`QuestionVarietyBiasDetector`を`adaptive`モジュールに追加した。
連続する同一タグの件数が閾値を超えた場合に偏りと判定するだけで、
実際の出題選定ロジック自体はアプリ側の責務とする。

## ReportReadTimeoutEscalationの追加

`ReportReadState`に記録された最終既読時刻から一定期間が過ぎても保護者
がレポートを確認していない場合に通知方法をエスカレーションしたい
場面向けに、`ReportReadTimeoutEscalation`を`guardian`モジュールに
追加した。`ReportReadState`自体は既読時刻の記録・問い合わせのみを
担うため、本クラスがその時刻と現在時刻の差分を見る。実際のエスカレ
ーション先選定・送信処理はアプリ側の責務とする。

## StreakRiskAlertの追加

`LearningStreak`が当日中に学習しないと途切れてしまう状態で、ミッション
日の残り時間が少なくなっている場合にリマインドしたい場面向けに、
`StreakRiskAlert`を`growth`モジュールに追加した。`LearningStreak`自体は
ストリークの計算のみを行うため、本クラスが「今日まだ学習していない」
かつ「残り時間が少ない」の両方を見る。実際のリマインド表示・通知送信
はアプリ側の責務とする。

## SyncConflictSeverityClassifierの追加

`OfflineSyncConflictResolver`が解決したコンフリクトについて、採用され
なかった側のデータが実質的に失われる重大なものか実害のない軽微な
ものかを分類したい場面向けに、`SyncConflictSeverityClassifier`を
`sync`モジュールに追加した。`OfflineSyncConflictResolver`自体はどちら
を採用するか（last-write-wins）のみを判定するため、本クラスが採用され
なかった側のpayloadを比較する。実際のログ記録・保護者への報告はアプリ
側の責務とする。

## GuardianGateRapidAttemptDetectorの追加

`GuardianGate`の計算チャレンジへの失敗試行が、通常の子どもの誤入力では
考えにくい短い間隔で連続している場合に警戒したい場面向けに、
`GuardianGateRapidAttemptDetector`を`guardian`モジュールに追加した。
`GuardianGateLockout`（連続失敗回数による一定時間ロック）とは異なり、
試行回数ではなく試行間隔の異常さを見る。実際の警戒時の対応（追加ロック
・保護者への通知等）はアプリ側の責務とする。

## AnswerLatencyFatigueTrendの追加

セッション中の解答時間が、単発の異常値ではなく徐々に遅くなっていく
傾向（集中力低下の疑い）を検知したい場面向けに、`AnswerLatencyFatigueTrend`
を`adaptive`モジュールに追加した。`AnswerLatencyOutlierFlag`（個々の解答
の所要時間が極端に短い/長い場合のフラグ）とは異なり、本クラスは直近の
解答時間列の前半と後半の平均を比較し、遅くなる傾向自体を見る。実際の
休憩提案・通知はアプリ側の責務とする。

## InventoryItemExpiryNoticeの追加

イベント配布等の期間限定アイテムの消費期限が近いことに気づけるよう
にしたい場面向けに、`InventoryItemExpiryNotice`を`growth`モジュールに
追加した。`InventorySnapshot`自体は所持アイテムIDの集合のみを保持し
期限の概念を持たないため、本クラスはアプリ側が別途管理する
「アイテムID→期限」の対応を受け取り、期限が近いものを抽出する。
実際の通知表示・期限切れ後の失効処理はアプリ側の責務とする。

## DuplicateSyncPayloadDetectorの追加

複数端末から同じ内容のデータが重複して同期キューに積まれていないか
を検知したい場面向けに、`DuplicateSyncPayloadDetector`を`sync`モジュール
に追加した。`OfflineSyncConflictResolver`（更新時刻が異なる競合の解決）
とは異なり、本クラスは内容（payload）が完全に一致するレコードが複数
存在するかのみを見る。実際の重複除去・サーバー側への問い合わせは
アプリ側の責務とする。

## MissionCompletionTimePreferenceの追加

通知タイミングの最適化のため、ミッション達成（学習完了）の履歴から
子どもが最も学習しやすい時間帯を推定したい場面向けに、
`MissionCompletionTimePreference`を`growth`モジュールに追加した。
達成時刻の履歴を時（0-23）ごとに集計し、最も件数が多い時を返すのみで、
実際の通知スケジューリングはアプリ側の責務とする。

## GuardianApprovalRequestBatchNoticeの追加

保護者承認待ちの申請が複数件溜まった場合に、個別通知の洪水を防ぐため
まとめて知らせたい場面向けに、`GuardianApprovalRequestBatchNotice`を
`guardian`モジュールに追加した。`GuardianNotificationDigestThrottle`
（直前の送信からの経過時間のみを見る時間ベースの抑制）とは異なり、
本クラスは承認待ち件数の閾値のみを見る。実際の通知のまとめ・送信処理
はアプリ側の責務とする。

## WeakNoteMisconceptionRelapseの追加

`WeakNotesAnalyzer.isOvercome()`で一度「克服した」と判定された誤解が、
その後再び同じ誤解タイプで誤答された（再発した）かを検知したい場面
向けに、`WeakNoteMisconceptionRelapse`を`weak`モジュールに追加した。
`WeakNotesAnalyzer`自体は克服判定のみを行い克服後の再発は見ないため、
本クラスが克服と判定された時刻以降の誤答のみを見る。実際の再学習の
案表示・保護者への報告はアプリ側の責務とする。

## GuardianTimezoneMismatchDetectorの追加

海外在住の保護者等、子どもと保護者の端末のタイムゾーンのUTCオフセット
が大きく異なる場合に、「今日のミッション」等の通知が保護者側では深夜に
届くような事態に気づけるようにしたい場面向けに、
`GuardianTimezoneMismatchDetector`を`guardian`モジュールに追加した。
`TimeZoneDriftDetector`（同一端末のタイムゾーンが前回記録時と変わって
いないかの検出）とは異なり、本クラスは子どもと保護者という異なる2台の
端末間のオフセット差を見る。実際の通知時刻の補正・表示はアプリ側の
責務とする。

## ExportSizeEstimatorの追加

`exportUserData`等が返すデータをJSON化した際のおおよそのバイト数を
見積もり、分割が必要かを判定したい場面向けに、`ExportSizeEstimator`を
`privacy`モジュールに追加した。`ExportChunker`自体は件数ベースで分割
するのみでバイト数は見ないため、本クラスは実際にJSON文字列化して
バイト数を測り、サイズベースで判定を補う。実際の分割保存・結合処理は
アプリ側（`ExportChunker`）の責務とする。

## EntitlementExpiryNoticeの追加

課金プランの有効期限切れが近いことを失効前に事前に知らせたい場面
向けに、`EntitlementExpiryNotice`を`entitlement`モジュールに追加した。
`EntitlementGracePeriod`（失効後の猶予期間判定）とは異なり、本クラス
は失効前の時点で期限が近づいていることに気づけるようにする。
`Entitlement`自体やストアからの期限取得はアプリ側（`EntitlementReader`
等のRevenueCat実装）の責務とし、本コアは期限までの残り時間の判定
のみを担う。実際の通知表示・更新手続きの案内はアプリ側の責務とする。

## CoinWalletStagnationNoticeの追加

コインが貯まり続けているにもかかわらず長期間使われていない（残高が
滞留している）ことに気づけるようにしたい場面向けに、
`CoinWalletStagnationNotice`を`growth`モジュールに追加した。
`CoinWallet`自体は残高の増減のみを行い使われていない期間は見ないため、
本クラスがアプリ側が別途記録する最終使用時刻と現在の残高を見て判定
する。実際のストア案内・通知表示はアプリ側の責務とする。

## SiblingProfileUsageBalanceの追加

同じ端末を共有する兄弟プロフィール間で、学習時間の配分が極端に
偏っていないかを検知したい場面向けに、`SiblingProfileUsageBalance`を
`profile`モジュールに追加した。`SiblingProfileSwitchSuggestion`（操作
が一定時間ないときに切替を促す）とは異なり、本クラスは累積の利用
時間比率のみを見る。実際の保護者への報告・利用時間の調整提案は
アプリ側の責務とする。

## SessionReviewModeRatioAlertの追加

セッション内の解答が復習モード（`Attempt.mode == 'review'`）に偏り
すぎていないかを検知したい場面向けに、`SessionReviewModeRatioAlert`
を`adaptive`モジュールに追加した。`QuestionVarietyBiasDetector`（出題
タグの偏り）とは異なり、本クラスは出題の内容ではなくモード（新規
学習か復習か）の比率のみを見る。実際の出題モードの切り替え判断は
アプリ側の責務とする。

## ProfilePhotoStalenessNoticeの追加

プロフィール写真が登録・最終更新から長期間変わっていないことに
気づけるようにしたい場面向けに、`ProfilePhotoStalenessNotice`を
`profile`モジュールに追加した。`ProfileAvatarRotationSuggester`
（成長段階の進化イベントをきっかけに変更を促す）とは異なり、本クラス
は単純に経過時間のみを見る。実際の更新案内UIの表示はアプリ側の責務
とする。

## WeeklyReportEngagementDeclineNoticeの追加

直近複数回分の週次レポートの既読率が継続して低い場合に、通知方法
自体の見直しを提案したい場面向けに、`WeeklyReportEngagementDeclineNotice`
を`guardian`モジュールに追加した。`ReportReadTimeoutEscalation`（直近
1件のレポートの未読が長期化した場合のエスカレーション）とは異なり、
本クラスは複数回のレポートにわたる既読傾向のみを見る。実際の通知
方法の変更案提示はアプリ側の責務とする。

## GuardianPinWeaknessDetectorの追加

保護者ゲートのPINが連番（"1234"等）や同一数字の繰り返し（"1111"等）
のような推測されやすいパターンでないかを検知したい場面向けに、
`GuardianPinWeaknessDetector`を`guardian`モジュールに追加した。
`GuardianPinRotationReminder`（最終変更からの経過時間）とは異なり、
本クラスはPINの値そのものの強度のみを見る。実際の設定時の警告表示・
再入力の強制はアプリ側の責務とする。

## UnitRecommendationIgnoredDetectorの追加

`UnitRecommendation`が提案した単元が、何度も提示されても学習されずに
無視され続けていないかを検知したい場面向けに、
`UnitRecommendationIgnoredDetector`を`question`モジュールに追加した。
`UnitRecommendation`自体は単元の優先順位付けのみを行い、提案が実際に
見送られ続けているかは見ないため、本クラスがアプリ側が記録する提示
回数を見る。実際の提案内容の変更・別単元への切り替えはアプリ側の
責務とする。

## MasteryRapidDecayDetectorの追加

`MasteryDecay`による減衰量が大きい単元を優先的に知らせたい場面向けに、
`MasteryRapidDecayDetector`を`question`モジュールに追加した。
`MasteryDecay`自体は減衰後のスコアを計算するのみで単元間の比較は
行わないため、本クラスが元のスコアとの差分を見る。実際の優先表示・
通知はアプリ側の責務とする。

## SettingsBackupStalenessNoticeの追加

`exportSettingsBackup`によるバックアップが長期間作成されていないこと
に気づけるようにしたい場面向けに、`SettingsBackupStalenessNotice`を
`privacy`モジュールに追加した。`exportSettingsBackup`自体はバックアップ
の生成・復元のみを行い最終作成時刻の追跡は見ないため、本クラスが
アプリ側が別途記録する最終バックアップ時刻を見る。実際のバックアップ
実行の案内はアプリ側の責務とする。

## OfflineOnlyModeSuggestionの追加

`RetryBackoffPolicy.hasExhaustedRetries`で再送を諦めるべきと判定された
アイテムが一定数以上溜まっている場合に、同期を諦めてオフライン専用
モードへの切り替えを提案したい場面向けに、`OfflineOnlyModeSuggestion`
を`sync`モジュールに追加した。`RetryBackoffPolicy`自体は1件ごとの再送
可否のみを判定するため、本クラスがキュー全体を見て複数件が諦め状態
にあるかを判定する。実際のモード切り替えUI・保護者への通知はアプリ側
の責務とする。

## DataErasureVerifierの追加

`eraseAllUserData`実行後、関連する各ストアが実際に空になったかを
検証したい場面向けに、`DataErasureVerifier`を`privacy`モジュールに
追加した。`eraseAllUserData`自体は削除処理を実行するのみで削除後の
確認は行わないため、本クラスがアプリ側から渡された削除後の件数
一覧を見る。実際の再削除・エラー報告はアプリ側の責務とする。

## 引き継がない・作らないもの

友達・ランキング・リーグ・マルチ対戦・マッチング、A/Bテスト、リテンション/動的価格、
screen_time連携、cross_app、Firebase直接利用、analytics SDK（既定なし）、freezed、
キット内の価格/無料期間ロジック、広告。
