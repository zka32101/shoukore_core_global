import 'package:intl/intl.dart';

import '../models/models.dart';

/// `RegionalProfile.locale`に基づく数値・日付・時刻のロケール対応フォーマッタ。
/// 「保護者ゲートの文言・数字表記が固定」という既存の課題（ADR参照）に対応し、
/// アプリ側が数字・日付表記をベタ書きしないよう、本コアにユーティリティとして
/// 用意する。文言そのもの（arb）は引き続きアプリ側の責務。
///
/// `date`/`time`は`package:intl`のロケールデータに依存するため、使用前に
/// `initializeDateFormatting(locale)`（`flutter_localizations`経由のMaterialApp
/// では通常自動済み）を呼んでおく必要がある。未初期化のロケールで呼ぶと
/// `LocaleDataException`になる。
class LocaleFormatter {
  LocaleFormatter(this.profile)
      : _number = NumberFormat.decimalPattern(profile.locale),
        _date = DateFormat.yMd(profile.locale),
        _time = DateFormat.Hm(profile.locale);

  final RegionalProfile profile;
  final NumberFormat _number;
  final DateFormat _date;
  final DateFormat _time;

  String number(num value) => _number.format(value);

  String date(DateTime value) => _date.format(value);

  String time(DateTime value) => _time.format(value);
}
