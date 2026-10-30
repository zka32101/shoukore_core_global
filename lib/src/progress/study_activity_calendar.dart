import '../models/models.dart';

/// [attempts]（教科非依存、単元を問わない全履歴）の`answeredAt`から、
/// 「学習した日」の集合を求める純関数。1日に複数回答していても1日として
/// 数える。時刻は呼び出し側がローカル時刻に変換済みのものを渡す想定
/// （タイムゾーン変換自体はアプリ側の責務）。
/// カレンダー表示など「学習ストリークを日付ベースで可視化する」用途で使う。
Set<DateTime> studiedDaysFromAttempts(List<Attempt> attempts) {
  return {
    for (final attempt in attempts)
      DateTime(attempt.answeredAt.year, attempt.answeredAt.month, attempt.answeredAt.day),
  };
}
