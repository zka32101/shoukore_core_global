import 'package:flutter_test/flutter_test.dart';
import 'package:shoukore_core_global/shoukore_core_global.dart';

void main() {
  const detector = CharacterCollectionChangeDetector();

  test('未所持→所持になったキャラをnewlyOwnedで検出する', () {
    const before = CharacterCollectionSnapshot(levelByCharacterId: {'onça': 1});
    const after = CharacterCollectionSnapshot(levelByCharacterId: {'onça': 1, 'capivara': 1});

    expect(detector.newlyOwned(before: before, after: after), {'capivara'});
  });

  test('既に所持済みのキャラはnewlyOwnedに含めない', () {
    const before = CharacterCollectionSnapshot(levelByCharacterId: {'onça': 1});
    const after = CharacterCollectionSnapshot(levelByCharacterId: {'onça': 2});

    expect(detector.newlyOwned(before: before, after: after), isEmpty);
  });

  test('レベルが上がったキャラをleveledUpで検出する', () {
    const before = CharacterCollectionSnapshot(levelByCharacterId: {'onça': 1, 'capivara': 2});
    const after = CharacterCollectionSnapshot(levelByCharacterId: {'onça': 3, 'capivara': 2});

    expect(detector.leveledUp(before: before, after: after), {'onça': 3});
  });

  test('新規所持(Lv0→1)もleveledUpに含める', () {
    const before = CharacterCollectionSnapshot(levelByCharacterId: {});
    const after = CharacterCollectionSnapshot(levelByCharacterId: {'onça': 1});

    expect(detector.leveledUp(before: before, after: after), {'onça': 1});
  });

  test('変化がなければ両方とも空', () {
    const snapshot = CharacterCollectionSnapshot(levelByCharacterId: {'onça': 2});

    expect(detector.newlyOwned(before: snapshot, after: snapshot), isEmpty);
    expect(detector.leveledUp(before: snapshot, after: snapshot), isEmpty);
  });
}
