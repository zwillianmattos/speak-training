import 'package:falandoingles/src/modules/speak_phrase/domain/usecases/get_phrases.dart';
import 'package:falandoingles/src/modules/speak_phrase/presenter/pages/phrase_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:uno/uno.dart';

import 'domain/repositories/phrase_repository.dart';
import 'external/datasources/phrase_datasource.dart';
import 'infra/datasources/phrase_datasource.dart';
import 'infra/repositories/phrase_repository.dart';
import 'presenter/pages/speak_phrase_page.dart';
import 'presenter/stores/speak_phrase_store.dart';
import 'presenter/stores/voice_store.dart';

class SpeakPhraseModule extends Module {
  @override
  List<Bind> get binds => [
        //utils
        Bind.factory((i) => Uno()),
        //datasource
        Bind.factory<IPhrasesDatasource>((i) => PhraseDataSource(i())),
        //repository
        Bind.factory<IPhraseRepository>((i) => PhraseRepository(i())),
        //usecase
        Bind.factory((i) => GetPhrases(i())),
        //store
        Bind.singleton((i) => FlutterTts()),
        Bind.factory((i) => SpeechToText()),
        Bind.singleton((i) => VoiceStore(i(), i())),
        Bind.singleton((i) => SpeakPhraseStore(i())),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => const PhrasePage()),
      ];
}
