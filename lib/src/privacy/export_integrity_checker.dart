/// `exportUserData`で書き出したデータ（または`exportUserDataAsJson`を
/// `jsonDecode`したもの）を再取り込みする前に、想定キー構成・型が揃っているか
/// 検証する純関数。端末移行時のインポート処理で、壊れたファイルや別形式の
/// データを誤って取り込むことを防ぐ。実際のファイル読み込み・インポート処理
/// 自体はアプリ側の責務とする。
class ExportIntegrityChecker {
  const ExportIntegrityChecker();

  /// [data]が`exportUserData`の出力として妥当な構造かどうかを検証し、
  /// 問題があれば説明文のリストを返す（問題なしなら空リスト）。
  List<String> validate(Map<String, dynamic> data) {
    final errors = <String>[];

    if (!data.containsKey('consent')) {
      errors.add('"consent"キーが存在しません');
    } else {
      final consent = data['consent'];
      if (consent != null) {
        if (consent is! Map) {
          errors.add('"consent"はMapまたはnullである必要があります');
        } else {
          if (consent['parentalConsentGiven'] is! bool) {
            errors.add('"consent.parentalConsentGiven"はbool型である必要があります');
          }
          if (consent['consentedAt'] != null && consent['consentedAt'] is! String) {
            errors.add('"consent.consentedAt"はString型またはnullである必要があります');
          }
          if (consent['policyVersion'] is! int) {
            errors.add('"consent.policyVersion"はint型である必要があります');
          }
        }
      }
    }

    if (!data.containsKey('progress')) {
      errors.add('"progress"キーが存在しません');
    } else {
      final progress = data['progress'];
      if (progress is! List) {
        errors.add('"progress"はList型である必要があります');
      } else {
        for (var i = 0; i < progress.length; i++) {
          final entry = progress[i];
          if (entry is! Map) {
            errors.add('"progress[$i]"はMap型である必要があります');
            continue;
          }
          if (entry['unitId'] is! String) {
            errors.add('"progress[$i].unitId"はString型である必要があります');
          }
          if (entry['score'] is! num) {
            errors.add('"progress[$i].score"は数値型である必要があります');
          }
          if (entry['lastPracticedAt'] != null && entry['lastPracticedAt'] is! String) {
            errors.add('"progress[$i].lastPracticedAt"はString型またはnullである必要があります');
          }
        }
      }
    }

    return errors;
  }

  /// [data]が妥当かどうかを真偽値で返す（[validate]の簡易版）。
  bool isValid(Map<String, dynamic> data) => validate(data).isEmpty;
}
