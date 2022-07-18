import 'package:flutter_modular/flutter_modular.dart';

import 'speak_phrase/speak_phrase_module.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes =>
      [ModuleRoute('/', module: SpeakPhraseModule())];
}
