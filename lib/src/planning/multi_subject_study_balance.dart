/// 複数教科間の学習量の偏りを判定する純関数。小学コレ！は複数教科
/// を横断するシリーズのため、1教科に極端に偏った学習を検知して
/// バランスの取れた学習を促したい場面向け。実際のバランス表示・
/// 促し方自体はアプリ側の責務とする。
class MultiSubjectStudyBalance {
  const MultiSubjectStudyBalance({this.imbalanceRatioThreshold = 3.0})
      : assert(imbalanceRatioThreshold > 1);

  /// 最も学習が進んでいる教科と最も遅れている教科の回答数比率が
  /// この値以上であれば偏りありと判定する。
  final double imbalanceRatioThreshold;

  /// [answeredCountBySubject]（教科IDごとの回答数）から、教科間の
  /// 学習量に偏りがあるかを判定する。教科が2件未満の場合は偏りなし
  /// とみなす。最も遅れている教科の回答数が0で、他に回答がある
  /// 教科が存在する場合は偏りありと判定する。
  bool isImbalanced(Map<String, int> answeredCountBySubject) {
    if (answeredCountBySubject.length < 2) {
      return false;
    }
    final counts = answeredCountBySubject.values.toList();
    final maxCount = counts.reduce((a, b) => a > b ? a : b);
    final minCount = counts.reduce((a, b) => a < b ? a : b);

    if (maxCount <= 0) {
      return false;
    }
    if (minCount <= 0) {
      return true;
    }
    return maxCount / minCount >= imbalanceRatioThreshold;
  }

  /// [answeredCountBySubject]のうち、最も回答数が少ない教科IDを返す。
  /// 空であれば`null`を返す。
  String? mostNeglectedSubject(Map<String, int> answeredCountBySubject) {
    if (answeredCountBySubject.isEmpty) {
      return null;
    }
    var neglected = answeredCountBySubject.entries.first;
    for (final entry in answeredCountBySubject.entries) {
      if (entry.value < neglected.value) {
        neglected = entry;
      }
    }
    return neglected.key;
  }
}
