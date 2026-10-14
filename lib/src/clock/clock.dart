/// 現在時刻の取得を抽象化する。`DateTime.now()` の直書きを禁止するための注入点。
abstract class Clock {
  DateTime now();
}

class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}

/// テスト用の固定時刻クロック。
class FixedClock implements Clock {
  FixedClock(this._current);

  DateTime _current;

  @override
  DateTime now() => _current;

  void advance(Duration d) => _current = _current.add(d);

  void set(DateTime t) => _current = t;
}
