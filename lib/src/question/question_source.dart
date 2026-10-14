import '../models/models.dart';

/// 問題の出題・採点・テンプレ生成を抽象化する。
/// カリキュラムJSON(`curriculum/{locale}.json`)の読み込みと問題生成の実装はアプリ/アダプタ側に委ねる。
abstract class QuestionSource {
  /// 指定ロケールの単元ツリーを読み込む。
  Future<List<Unit>> loadUnits(String locale);

  /// 指定単元・目標難易度で問題を1件生成する。
  Future<Question> generate({
    required String unitId,
    required double targetDifficulty,
  });

  /// 採点する。`chosenId` は選択肢IDまたは数値入力の文字列表現。
  bool checkAnswer(Question question, String chosenId) => question.answer == chosenId;
}
