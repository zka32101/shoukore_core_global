import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const prompt = EntitlementRestorePrompt();

  test('以前のアンロック記録がなければ促さない', () {
    const current = Entitlement(unlockedSubjectIds: {});
    expect(
      prompt.shouldPromptRestore(previouslyUnlockedSubjectIds: const {}, current: current),
      isFalse,
    );
  });

  test('以前アンロックしていた教科が現在も含まれていれば促さない', () {
    const current = Entitlement(unlockedSubjectIds: {'science'});
    expect(
      prompt.shouldPromptRestore(
        previouslyUnlockedSubjectIds: const {'science'},
        current: current,
      ),
      isFalse,
    );
  });

  test('以前アンロックしていた教科が現在失われていれば復元を促す', () {
    const current = Entitlement(unlockedSubjectIds: {});
    expect(
      prompt.shouldPromptRestore(
        previouslyUnlockedSubjectIds: const {'science'},
        current: current,
      ),
      isTrue,
    );
  });

  test('premiumであれば常にアンロック扱いのため促さない', () {
    const current = Entitlement(unlockedSubjectIds: {}, isPremium: true);
    expect(
      prompt.shouldPromptRestore(
        previouslyUnlockedSubjectIds: const {'science'},
        current: current,
      ),
      isFalse,
    );
  });
}
