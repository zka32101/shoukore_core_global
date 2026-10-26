/// 問題文の読み上げ機能を自動提示すべきかどうかを判定する純関数。
/// 低学年ほど読み上げの恩恵が大きく、また問題文が長いほど読み上げの
/// 有用性が高まるため、学年と問題文の長さの両方を見る。実際の読み
/// 上げ音声の再生・UI表示自体はアプリ側の責務とする。
class ReadAloudEligibilityDetector {
  const ReadAloudEligibilityDetector({
    this.maxGradeForAutoReadAloud = 2,
    this.longTextThreshold = 40,
  })  : assert(maxGradeForAutoReadAloud > 0),
        assert(longTextThreshold > 0);

  /// この学年以下であれば、問題文の長さに関わらず読み上げ対象とする。
  final int maxGradeForAutoReadAloud;

  /// 問題文の文字数がこの値以上であれば読み上げ対象とする。
  final int longTextThreshold;

  /// [gradeLevel]（学年）が[maxGradeForAutoReadAloud]以下、または
  /// [questionTextLength]（問題文の文字数）が[longTextThreshold]
  /// 以上であれば、読み上げ対象と判定する。
  bool isEligible(int gradeLevel, int questionTextLength) {
    return gradeLevel <= maxGradeForAutoReadAloud ||
        questionTextLength >= longTextThreshold;
  }
}
