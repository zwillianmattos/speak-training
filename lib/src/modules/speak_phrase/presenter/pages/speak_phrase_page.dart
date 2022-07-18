import 'package:falandoingles/src/modules/speak_phrase/presenter/states/voice_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/themes/app_theme.dart';
import '../../../../core/utils/validate_phrase.dart';
import '../../domain/entities/phrase.dart';
import '../states/speak_phrase_state.dart';
import '../stores/speak_phrase_store.dart';
import '../stores/voice_store.dart';

class SpeakPhrasePage extends StatefulWidget {
  const SpeakPhrasePage({Key? key}) : super(key: key);

  @override
  State<SpeakPhrasePage> createState() => _SpeakPhrasePageState();
}

class _SpeakPhrasePageState extends State<SpeakPhrasePage> {
  @override
  void initState() {
    super.initState();
    context.read<SpeakPhraseStore>().fetchPhases();
  }

  @override
  Widget build(BuildContext context) {
    final speakerStore = context.watch<VoiceStore>();
    final speakerState = speakerStore.value;
    Widget recognition = const Text("");

    final store = context.watch<SpeakPhraseStore>();
    final state = store.value;
    Widget child = Container();
    Widget currentPhraseComponent = Container();

    Phrase? currentPhrase;

    if (state is LoadingSpeakPhraseState) {
      child = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is ErrorSpeakPhraseState) {
      child = Center(
        child: Text(state.message),
      );
    }

    if (state is SuccessSpeakPhraseState) {
      child = ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 30),
        itemCount: state.phrase.length,
        itemBuilder: (context, index) {
          final phrase = state.phrase[index];
          return ListTile(title: Text("${phrase.content}"));
        },
      );

      currentPhrase = state.phrase[12];
      List<dynamic> content =
          currentPhrase.content!.split(' ').map((e) => e).toList();
      if (speakerState is StopVoiceState) {
        recognition = Text(speakerState.recognizedWords);
      }

      currentPhraseComponent = Column(
        children: [
          speakerState is StopVoiceState
              ? _resultRecognition(currentPhrase, speakerState.recognizedWords)
              : Row(
                  children: [
                    ...content.map((e) => _card(
                        Text(
                          e,
                          style: const TextStyle(
                              color: AppTheme.nearlyWhite, fontSize: 24),
                        ),
                        backgroundColor: true)),
                  ],
                ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Speak Phrase'),
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          currentPhraseComponent,
          Center(
            child: recognition,
          ),
        ],
      ),
      // body: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 8),
      //   child: child,
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: speakerStore.value is StopVoiceState
            ? speakerStore.startListening
            : speakerStore.stopListening,
        tooltip: 'Listen',
        backgroundColor:
            speakerStore.value is StopVoiceState ? Colors.blue : Colors.red,
        child: const Icon(Icons.mic),
      ),
    );
  }

  Widget _resultRecognition(Phrase currentPhrase, String recognizedWords) {
    List? result = validatePhrase(currentPhrase, recognizedWords);

    if (result == null) {
      return Container();
    }

    List<dynamic>? invalid = result.map((e) {
      if (e['invalid'] != '') return e['correct'];
    }).toList();
    List<dynamic> correct = result.map((e) => e['correct']).toList();
    List<dynamic> content =
        currentPhrase.content!.split(' ').map((e) => e).toList();

    print(invalid);
    print(correct);
    print(content);
    return Stack(
      children: [
        Row(
          children: [
            ...content.map((e) => Text(
                  e,
                  style: const TextStyle(
                      color: AppTheme.nearlyWhite, fontSize: 24),
                )),
          ],
        ),
        if (correct.isNotEmpty)
          Row(
            children: [
              ...correct.map(
                (e) => Text(
                  e,
                  style: const TextStyle(color: Colors.green, fontSize: 24),
                ),
              )
            ],
          ),
        if (invalid.isNotEmpty)
          ...invalid.map(
            (e) => Row(children: [
              Text(
                "$e",
                style: const TextStyle(color: Colors.red, fontSize: 24),
              ),
            ]),
          ),
      ],
    );
  }

  Widget _card(Widget textW, {bool backgroundColor = false, String? text}) {
    return InkWell(
      onTap: () {
        if (text != null) {
          final store = context.watch<VoiceStore>();
          store.speak(text);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ? AppTheme.grey : Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        ),
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            textW,
          ],
        ),
      ),
    );
  }
}
