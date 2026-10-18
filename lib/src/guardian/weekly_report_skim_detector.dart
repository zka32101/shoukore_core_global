import 'weekly_report.dart';

/// 保護者が`WeeklyReport`を開封したものの、閲覧時間が極端に短く実質的に
/// 内容を確認していない「流し見」状態を検知する純関数。`ReportReadState`は
/// 既読/未読の二値のみを扱い、閲覧の充実度は見ないため、本クラスが
/// アプリ側から渡される閲覧時間を見てその充実度を判定する。実際の
/// 「詳しく見る」案内の表示はアプリ側の責務とする。
class WeeklyReportSkimDetector {
  const WeeklyReportSkimDetector({this.minViewDurationPerUnit = const Duration(seconds: 3)});

  /// 単元1件あたり、これ未満の閲覧時間しかなければ流し見とみなす。
  final Duration minViewDurationPerUnit;

  /// [report]に含まれる単元数に対して、[viewDuration]（レポートを開封して
  /// から閉じるまでの閲覧時間）が[minViewDurationPerUnit]×単元数未満で
  /// あれば、流し見と判定する。単元が0件の場合は`false`を返す。
  bool isSkimRead({required WeeklyReport report, required Duration viewDuration}) {
    if (report.units.isEmpty) return false;
    final expectedMinimum = minViewDurationPerUnit * report.units.length;
    return viewDuration < expectedMinimum;
  }
}
