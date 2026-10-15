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

## 引き継がない・作らないもの

友達・ランキング・リーグ・マルチ対戦・マッチング、A/Bテスト、リテンション/動的価格、
screen_time連携、cross_app、Firebase直接利用、analytics SDK（既定なし）、freezed、
キット内の価格/無料期間ロジック、広告。
