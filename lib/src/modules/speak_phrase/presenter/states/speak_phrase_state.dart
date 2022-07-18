import 'package:falandoingles/src/modules/speak_phrase/domain/entities/phrase.dart';

abstract class SpeakPhraseState {
  get phrase => null;
  get currentPhrase => null;
}

class SuccessSpeakPhraseState implements SpeakPhraseState {
  final int currentPhrase;
  final List<Phrase> phrase;

  SuccessSpeakPhraseState(this.phrase, this.currentPhrase): super();
}

class EmptySpeakPhraseState extends SpeakPhraseState {
  EmptySpeakPhraseState() : super();
}

class LoadingSpeakPhraseState extends SpeakPhraseState {}

class ErrorSpeakPhraseState extends SpeakPhraseState {
  final String message;

  ErrorSpeakPhraseState(this.message);
}
