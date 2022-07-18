import '../../domain/entities/phrase.dart';

class PhraseAdapter {
  PhraseAdapter._();

  static Phrase fromJson(dynamic data) {
    return Phrase(
      id: data['id'],
      content: data['content'],
      description: data['description'],
      level: data['level'],
    );
  }
}
