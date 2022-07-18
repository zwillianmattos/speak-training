import 'package:falandoingles/src/modules/speak_phrase/domain/repositories/phrase_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/phrase.dart';
import '../errors/errors.dart';

abstract class IGetPhrases {
  Future<Either<IPhraseException, List<Phrase>>> call();
}

class GetPhrases implements IGetPhrases {
  final IPhraseRepository repository;

  GetPhrases(this.repository);

  @override
  Future<Either<IPhraseException, List<Phrase>>> call() async {
    return await repository.getPhrases();
  }
}
