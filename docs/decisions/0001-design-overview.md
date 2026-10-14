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

## 引き継がない・作らないもの

友達・ランキング・リーグ・マルチ対戦・マッチング、A/Bテスト、リテンション/動的価格、
screen_time連携、cross_app、Firebase直接利用、analytics SDK（既定なし）、freezed、
キット内の価格/無料期間ロジック、広告。
