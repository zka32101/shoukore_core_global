import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const detector = TimeZoneDriftDetector();

  test('未記録ならfalse', () {
    expect(
      detector.hasDrifted(lastRecordedTimeZone: null, currentTimeZone: 'Asia/Tokyo'),
      isFalse,
    );
  });

  test('同じタイムゾーンならfalse', () {
    expect(
      detector.hasDrifted(
        lastRecordedTimeZone: 'Asia/Tokyo',
        currentTimeZone: 'Asia/Tokyo',
      ),
      isFalse,
    );
  });

  test('異なるタイムゾーンならtrue', () {
    expect(
      detector.hasDrifted(
        lastRecordedTimeZone: 'Asia/Tokyo',
        currentTimeZone: 'America/Sao_Paulo',
      ),
      isTrue,
    );
  });
}
