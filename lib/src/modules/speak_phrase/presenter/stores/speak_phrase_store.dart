import 'package:flutter/material.dart';

import '../states/speak_phrase_state.dart';
import '../../domain/usecases/get_phrases.dart';

class SpeakPhraseStore extends ValueNotifier<SpeakPhraseState> {
  final IGetPhrases getPhrases;

  SpeakPhraseStore(this.getPhrases) : super(EmptySpeakPhraseState());

  void emit(SpeakPhraseState newState) => value = newState;

  Future<void> fetchPhases() async {
    emit(LoadingSpeakPhraseState());

    final result = await getPhrases.call();

    final newState = result.fold((l) {
      return ErrorSpeakPhraseState(l.message);
    }, (r) {
      return SuccessSpeakPhraseState(r, 0);
    });

    emit(newState);
  }
}
