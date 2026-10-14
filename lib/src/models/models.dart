/// 日付のみを比較するため UTC の 0 時に揃える。
DateTime dateOnly(DateTime d) => DateTime.utc(d.year, d.month, d.day);

/// 単元。教科・単元は常にカリキュラムJSON上のIDで表す（日本語ローマ字IDの直書き禁止）。
/// 表示名は `titleKey`（arbのキー）として持ち、文字列そのものは持たない。
class Unit {
  const Unit({
    required this.id,
    required this.subjectId,
    required this.grade,
    required this.titleKey,
    this.parentId,
    this.order = 0,
    this.estimatedQuestions = 0,
    this.templateIds = const [],
  });

  factory Unit.fromJson(Map<String, dynamic> j) => Unit(
        id: j['id'] as String,
        subjectId: j['subjectId'] as String,
        grade: j['grade'] as int,
        titleKey: j['titleKey'] as String,
        parentId: j['parentId'] as String?,
        order: (j['order'] as int?) ?? 0,
        estimatedQuestions: (j['estimatedQuestions'] as int?) ?? 0,
        templateIds: (j['templateIds'] as List<dynamic>?)?.cast<String>() ?? const [],
      );

  final String id;
  final String subjectId;
  final int grade;
  final String titleKey;
  final String? parentId;
  final int order;
  final int estimatedQuestions;

  /// この単元で使える問題テンプレID一覧。
  final List<String> templateIds;
}

enum QuestionType { choice, numeric, order }

class Question {
  const Question({
    required this.id,
    required this.unitId,
    required this.type,
    required this.difficulty,
    required this.choices,
    required this.answer,
    required this.explanationId,
    this.misconceptionTags = const {},
    this.version = 1,
  }) : assert(difficulty >= 0 && difficulty <= 1);

  final String id;
  final String unitId;
  final QuestionType type;

  /// 基準正答率 0〜1。
  final double difficulty;
  final List<String> choices;
  final String answer;
  final String explanationId;

  /// 誤答選択肢ID → 誤解の型（例: sign_error）。
  final Map<String, String> misconceptionTags;
  final int version;
}

class Attempt {
  const Attempt({
    required this.questionId,
    required this.unitId,
    required this.correct,
    required this.answeredAt,
    this.chosenId,
    this.elapsedMs = 0,
    this.mode = 'practice',
  });

  final String questionId;
  final String unitId;
  final bool correct;
  final String? chosenId;
  final DateTime answeredAt;
  final int elapsedMs;
  final String mode;
}

class Mastery {
  const Mastery({required this.unitId, required this.score, this.lastPracticedAt});

  final String unitId;

  /// 0〜1。未学習は 0。
  final double score;
  final DateTime? lastPracticedAt;
}

/// アプリ側の課金状態をコアへ渡す読み取り専用モデル。価格・無料期間ロジックはコアに置かない。
class Entitlement {
  const Entitlement({required this.unlockedSubjectIds, this.isPremium = false});

  final Set<String> unlockedSubjectIds;
  final bool isPremium;

  bool isUnlocked(String subjectId) => isPremium || unlockedSubjectIds.contains(subjectId);
}

/// 保護者同意の記録。LGPD第14条「特定かつ目立つ形の同意」に対応するための最小構造。
class ConsentRecord {
  const ConsentRecord({
    required this.parentalConsentGiven,
    this.consentedAt,
    this.policyVersion = 1,
  });

  final bool parentalConsentGiven;
  final DateTime? consentedAt;
  final int policyVersion;
}

/// 地域コンプライアンス設定。regional/{locale}.yaml から読み込む。
class RegionalProfile {
  const RegionalProfile({
    required this.locale,
    required this.ageOfConsent,
    required this.guardianConsentRequired,
    required this.dailyResetHour,
    required this.timeZone,
    required this.screenTimeLimitMinutes,
    required this.profilingAdsAllowed,
  });

  final String locale;
  final int ageOfConsent;
  final bool guardianConsentRequired;

  /// DailyMission 等の日付境界時刻（0-23）。固定5:00は廃止し地域ごとに設定可能にする。
  final int dailyResetHour;
  final String timeZone;

  /// 0 の場合は制限なし。
  final int screenTimeLimitMinutes;
  final bool profilingAdsAllowed;
}
