import '../models/models.dart';

/// セッション内の解答が復習モード（`Attempt.mode == 'review'`）に
/// 偏りすぎていないかを判定する純関数。`QuestionVarietyBiasDetector`
/// （出題タグの偏り）とは異なり、本クラスは出題の内容ではなく
/// モード（新規学習か復習か）の比率のみを見る。実際の出題モードの
/// 切り替え判断はアプリ側の責務とする。
class SessionReviewModeRatioAlert {
  const SessionReviewModeRatioAlert({
    this.minimumSampleSize = 5,
    this.reviewRatioThreshold = 0.8,
  });

  /// 判定に必要な最小解答件数。これ未満なら判定しない。
  final int minimumSampleSize;

  /// 復習モードの割合がこれ以上であれば偏りありと判定する。
  final double reviewRatioThreshold;

  /// [attempts]のうち`mode == 'review'`の割合が[reviewRatioThreshold]
  /// 以上であれば、復習モードに偏りすぎと判定する。[attempts]の件数が
  /// [minimumSampleSize]未満の場合は判定しない。
  bool isTooReviewHeavy(List<Attempt> attempts) {
    if (attempts.length < minimumSampleSize) return false;

    final reviewCount = attempts.where((a) => a.mode == 'review').length;
    return reviewCount / attempts.length >= reviewRatioThreshold;
  }
}
