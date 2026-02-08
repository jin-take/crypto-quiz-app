import 'package:test/test.dart';
import 'package:crypto_quiz_app/service/character_service.dart';

void main() {
  test('CharacterService calculates level based on score', () {
    final status = CharacterService.calculateCharacterStatus(0);
    expect(status.level, 1);

    final status2 = CharacterService.calculateCharacterStatus(60);
    expect(status2.level, 2);

    final status3 = CharacterService.calculateCharacterStatus(160);
    expect(status3.level, 3);
  });
}
