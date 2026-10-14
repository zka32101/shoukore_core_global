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

- `verified: true`（Web検索で確認できたもの）: Números 1º-3º、Álgebra 1º、
  Grandezas e medidas 1º・5º（体積の導入）、Probabilidade e estatística 1º-3º。
- `verified: false`（要検証・現地教員レビュー前提）: 上記以外すべて。特に
  Geometria・Álgebra 2º-5ºは全学年ともWeb検索で裏付けが取れていない。
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

## 引き継がない・作らないもの

友達・ランキング・リーグ・マルチ対戦・マッチング、A/Bテスト、リテンション/動的価格、
screen_time連携、cross_app、Firebase直接利用、analytics SDK（既定なし）、freezed、
キット内の価格/無料期間ロジック、広告。
