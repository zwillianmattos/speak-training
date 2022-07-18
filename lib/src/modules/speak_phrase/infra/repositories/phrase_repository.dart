import 'package:falandoingles/src/modules/speak_phrase/infra/adapters/phrase_adapter.dart';
import 'package:fpdart/src/either.dart';
import 'package:falandoingles/src/modules/speak_phrase/domain/errors/errors.dart';
import 'package:falandoingles/src/modules/speak_phrase/domain/entities/phrase.dart';
import 'package:falandoingles/src/modules/speak_phrase/domain/repositories/phrase_repository.dart';
import 'package:falandoingles/src/modules/speak_phrase/infra/datasources/phrase_datasource.dart';

class PhraseRepository extends IPhraseRepository {
  final IPhrasesDatasource postsDatasource;

  PhraseRepository(this.postsDatasource);

  @override
  Future<Either<IPhraseException, List<Phrase>>> getPhrases() async {
    try {
      final data = await postsDatasource.getPhrases();
      final phrases = data.map(PhraseAdapter.fromJson).toList();
      return right(phrases);
    } on IPhraseException catch (e) {
      return left(e);
    }
  }
}
