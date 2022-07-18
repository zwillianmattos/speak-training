
import 'package:falandoingles/src/modules/speak_phrase/domain/errors/errors.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/phrase.dart';

abstract class IPhraseRepository {
  Future<Either<IPhraseException, List<Phrase>>> getPhrases();
}