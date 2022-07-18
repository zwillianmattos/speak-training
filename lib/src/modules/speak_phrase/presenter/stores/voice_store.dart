import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../states/voice_state.dart';

class VoiceStore extends ValueNotifier<VoiceState> {
  final FlutterTts flutterTts;
  final SpeechToText speechToText;
  bool speechEnabled = false;

  VoiceStore(this.speechToText, this.flutterTts) : super(StopVoiceState("")) {
    initSpeech();
    initTts();
  }

  initTts() async {
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  Future<dynamic> speak(String key) async {
    return await flutterTts.speak(key);
  }

  Future<dynamic> stop() async {
    return await flutterTts.stop();
  }

  void emit(VoiceState newState) => value = newState;

  void initSpeech() async {
    speechEnabled = await speechToText.initialize();
  }

  void startListening() async {
    print("Start listening");
    await speechToText.listen(onResult: _onSpeechResult, localeId: 'en_US');
    emit(RecordVoiceState(""));
  }

  void stopListening() async {
    print("Stop listening");
    await speechToText.stop();
    emit(StopVoiceState(""));
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    emit(ResultVoiceState(result.recognizedWords));
  }
}
