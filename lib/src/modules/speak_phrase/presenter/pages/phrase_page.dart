import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/themes/app_theme.dart';
import '../../../../core/utils/validate_phrase.dart';
import '../states/speak_phrase_state.dart';
import '../states/voice_state.dart';
import '../stores/speak_phrase_store.dart';
import '../../domain/entities/phrase.dart';
import '../stores/voice_store.dart';

class PhrasePage extends StatefulWidget {
  const PhrasePage({Key? key}) : super(key: key);

  @override
  State<PhrasePage> createState() => _PhrasePageState();
}

class _PhrasePageState extends State<PhrasePage> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<SpeakPhraseStore>().fetchPhases();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<SpeakPhraseStore>();
    final state = store.value;

    Widget child = Container();
    Widget step = Container();
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
      List<Phrase> phraseList = state.phrase;

      child = _conteudo(phraseList);
      step = _step(phraseList);
    }
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _appbar(),
          step,
          const SizedBox(
            height: 80,
          ),
          child,
        ]),
      ),
    );
  }

  Widget _conteudo(List<Phrase> phrases) {
    final voiceStore = context.watch<VoiceStore>();
    final voicestate = voiceStore.value;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            _buttonIcon(
                icon: const Icon(
                  Icons.audiotrack,
                  color: Colors.blue,
                ),
                callback: () {
                  context
                      .read<VoiceStore>()
                      .speak(phrases[currentIndex].content.toString());
                }),
            const SizedBox(
              height: 15,
            ),
            ValueListenableBuilder(
                valueListenable: voiceStore,
                builder: (_, value, w) {
                  if (value is StopVoiceState) {
                    var text = value.recognizedWords;
                    if (text != "") {
                      
                      return _resultRecognition(phrases[currentIndex], text);
                    }
                  }

                  return Text(
                    "${phrases[currentIndex].content}",
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  );
                }),
            const SizedBox(
              height: 50,
            ),
            _buttonIcon(
                icon: Icon(
                  Icons.mic,
                  color:
                      (voicestate is StopVoiceState) ? Colors.blue : Colors.red,
                  size: 32,
                ),
                callback: (voicestate is StopVoiceState)
                    ? voiceStore.startListening
                    : voiceStore.stopListening),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buttonIcon(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.blue,
                    ),
                    callback: () {
                      setState(() {
                        print(currentIndex);
                        voiceStore.stopListening();
                        if (currentIndex > 0) {
                          currentIndex--;
                        } else {
                          currentIndex = 0;
                        }
                      });
                    }),
                _buttonIcon(
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blue,
                    ),
                    callback: () {
                      print(currentIndex);

                      voiceStore.stopListening();
                      setState(() {
                        if (currentIndex >= 0 &&
                            currentIndex <= phrases.length) {
                          currentIndex++;
                        } else {
                          currentIndex = 0;
                        }
                      });
                    }),
              ],
            )
          ],
        )
      ],
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            Positioned(
              child: Row(
                children: [
                  ...content.map((e) => InkWell(
                        onTap: () => context.read<VoiceStore>().speak("$e"),
                        child: Text(
                          "$e ",
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      )),
                ],
              ),
            ),
            if (correct.isNotEmpty)
              Positioned(
                child: Row(
                  children: [
                    ...correct.map(
                      (e) => Text(
                        "$e ",
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            if (invalid.isNotEmpty)
              Positioned(
                child: Row(children: [
                  ...invalid.map(
                    (e) => InkWell(
                      onTap: e == null
                          ? null
                          : () {
                              context.read<VoiceStore>().speak("$e");
                            },
                      child: Text(
                        "$e ",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: e == null ? Colors.transparent : Colors.red,
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
          ],
        ),
      ],
    );
  }

  Widget _appbar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buttonIcon(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.blue,
            ),
            callback: () {}),
        const Text(
          "Phrases",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        _buttonIcon(
          icon: const Icon(
            Icons.menu,
            color: Colors.blue,
          ),
          callback: () {},
        )
      ],
    );
  }

  Widget _step(List<Phrase> phraseList) {
    return SizedBox(
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 10.0,
          trackShape: const RoundedRectSliderTrackShape(),
          activeTrackColor: Colors.blue.shade800,
          inactiveTrackColor: Colors.blue.shade100,
          thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 0, pressedElevation: 0, elevation: 0),
          thumbColor: Colors.blue,
          overlayColor: Colors.blueAccent.withOpacity(0.2),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 32.0),
          tickMarkShape: const RoundSliderTickMarkShape(),
          activeTickMarkColor: Colors.blueAccent,
          inactiveTickMarkColor: Colors.white,
          valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
          valueIndicatorColor: Colors.black,
          valueIndicatorTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        child: Slider(
          value: currentIndex.toDouble() + 1,
          max: phraseList.length.toDouble(),
          divisions: phraseList.length,
          label: (currentIndex.toDouble() + 1).round().toString(),
          onChanged: (double value) {},
        ),
      ),
    );
  }

  Widget _buttonIcon({
    required Widget icon,
    Function()? callback,
  }) {
    return TextButton(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all<double>(3),
            padding:
                MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(15)),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9.0),
            )),
            shadowColor:
                MaterialStateProperty.all<Color>(Colors.grey.withOpacity(0.8)),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white)),
        onPressed: callback,
        child: icon);
  }
}
