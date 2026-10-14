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

      // 既定ロケール(pt_BR)でpt_BRのカリキュラム単元一覧・arb文言が表示される。
      expect(find.byKey(const Key('unit_mat_numeros_1')), findsOneWidget);
      expect(find.text('Para os responsáveis'), findsOneWidget);

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

      // ホームに戻ってロケールをjaに切り替えると、日本語カリキュラム・arb文言に切り替わる。
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

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
