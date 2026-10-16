import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const cascade = PhotoConsentExpiryCascade();

  test('保存済み写真がなければ削除不要', () {
    expect(
      cascade.shouldDeleteStoredPhoto(consent: null, hasStoredPhoto: false),
      isFalse,
    );
  });

  test('同意がnullで写真が保存済みなら削除すべき', () {
    expect(
      cascade.shouldDeleteStoredPhoto(consent: null, hasStoredPhoto: true),
      isTrue,
    );
  });

  test('同意が取り消されていて写真が保存済みなら削除すべき', () {
    const consent = ProfilePhotoConsent(granted: false);
    expect(
      cascade.shouldDeleteStoredPhoto(consent: consent, hasStoredPhoto: true),
      isTrue,
    );
  });

  test('同意が有効で写真が保存済みなら削除不要', () {
    const consent = ProfilePhotoConsent(granted: true);
    expect(
      cascade.shouldDeleteStoredPhoto(consent: consent, hasStoredPhoto: true),
      isFalse,
    );
  });
}
