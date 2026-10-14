import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global_example/main.dart';

void main() {
  // 1つのtestWidgets内でシナリオを連結し、pumpWidgetを1回だけ呼ぶ。
  // （Flutter test環境では複数のtestWidgetsでpumpWidgetを繰り返すとアセット読み込みの
  //  非同期処理がテスト間で干渉し、2回目以降でpumpAndSettleがハングする既知の問題がある）
  testWidgets(
    'shoukore_core_global 結合確認: pt_BR→ja切替・出題採点・保護者ゲート',
    (tester) async {
      await tester.pumpWidget(const ShoukoreExampleApp());
      await tester.pumpAndSettle();

      // 既定ロケール(pt_BR)でpt_BRのカリキュラム単元一覧が表示される。
      expect(find.byKey(const Key('unit_mat_numeros_1')), findsOneWidget);

      // 単元数が増え一覧が画面に収まらないため、保護者ゲートのタイルはスクロールして確認する。
      await tester.scrollUntilVisible(find.byKey(const Key('guardianGateTile')), 300.0);
      expect(find.text('Para os responsáveis'), findsOneWidget);
      await tester.scrollUntilVisible(find.byKey(const Key('unit_mat_numeros_1')), -300.0);

      // 単元をタップすると出題され、回答するとprogressのmasteryが更新される。
      await tester.tap(find.byKey(const Key('unit_mat_numeros_1')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('masteryText')), findsOneWidget);
      expect(find.text('mastery: 0%'), findsOneWidget);

      final choiceButtons = find.byType(ElevatedButton);
      expect(choiceButtons, findsWidgets);
      await tester.tap(choiceButtons.first);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('feedbackText')), findsOneWidget);

      // 出題画面にgrowth状態（stage/coins/mission進捗）が表示される。
      // 閾値(10問)に満たないため、正誤に関わらずstageはeggのまま。
      expect(find.byKey(const Key('growthStatusText')), findsOneWidget);
      expect(find.textContaining('stage: egg'), findsOneWidget);

      // ホームに戻って週次レポートを開くと、直前の回答が集計に反映されている。
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // ホームにもgrowth状態タイルが表示され、出題画面と状態を共有している。
      await tester.scrollUntilVisible(find.byKey(const Key('growthStatusTile')), -300.0);
      expect(find.byKey(const Key('growthStatusTile')), findsOneWidget);

      await tester.scrollUntilVisible(find.byKey(const Key('weeklyReportTile')), 300.0);
      await tester.tap(find.byKey(const Key('weeklyReportTile')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('weeklyReportAccuracyText')), findsOneWidget);
      expect(find.byKey(const Key('weeklyReportUnit_mat_numeros_1')), findsOneWidget);
      expect(find.byKey(const Key('weeklyReportNoDataText')), findsNothing);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.byKey(const Key('unit_mat_numeros_1')), -300.0);

      // ロケールをjaに切り替えると、日本語カリキュラム・arb文言に切り替わる。
      await tester.tap(find.byKey(const Key('localeJaButton')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('unit_sansuu_1')), findsOneWidget);
      expect(find.text('保護者の方へ'), findsOneWidget);

      // 保護者ゲートは誤答では通過できない。
      await tester.tap(find.byKey(const Key('guardianGateTile')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '1');
      await tester.tap(find.text('確認'));
      await tester.pumpAndSettle();
      expect(find.text('答えが正しくありません。もう一度お試しください。'), findsOneWidget);
    },
  );
}
