import 'package:falandoingles/core/enum/phrase_category.dart';
import 'package:falandoingles/core/model/invalid_phrase.dart';
import 'package:falandoingles/core/model/phrase.dart';
import 'package:falandoingles/core/repositories/common_expressions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ListPhrasesPage extends StatefulWidget {
  final PhraseCategory phraseCategory;
  const ListPhrasesPage({Key? key, required this.phraseCategory})
      : super(key: key);

  @override
  State<ListPhrasesPage> createState() => _ListPhrasesPageState();
}

class _ListPhrasesPageState extends State<ListPhrasesPage> {
  final SpeechToText _speechToText = SpeechToText();
  late List<Phrase> phrases = [];
  late List<InvalidPhrase>? invalidas = [];
  FlutterTts flutterTts = FlutterTts();

  bool isLoading = false;

  int currentIndex = 0;
  bool _speechEnabled = false;
  String _lastWords = '';

   @override
  void dispose() {
    print("Disposing second route");
    super.dispose();
    _speechToText.stop();
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _loadData();
    _initTts();
  }

  _initTts() async {
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  Future _speak(String key) async {
    var result = await flutterTts.speak(key);
  }

  Future _stop() async {
    var result = await flutterTts.stop();
  }

  _loadData() async {
    setState(() {
      isLoading = true;
    });
    phrases = await getCommonExpressions(widget.phraseCategory);

    setState(() {
      isLoading = false;
    });
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    // var locales = await _speechToText.locales();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult, localeId: 'en_US');
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      validatePhrase(phrases[currentIndex], result.recognizedWords);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Falando App"),
      ),
      body: Column(children: [
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: phrases.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    ListTile(
                        title: Text("${phrases[index].content}"),
                        selected: currentIndex == index ? true : false,
                        leading: phrases[index].correct == 2
                            ? Icon(Icons.check_box_outline_blank)
                            : phrases[index].correct == 1
                                ? Icon(Icons.check)
                                : Icon(Icons.error),
                        trailing: IconButton(
                            onPressed: () {
                              _speak("${phrases[index].content}");
                            },
                            icon: Icon(Icons.audiotrack)),
                        onTap: () {
                          setState(() {
                            currentIndex = index;
                            invalidas = [];
                          });
                        }),
                    if (currentIndex == index)
                      ...?invalidas
                          ?.map((e) => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${e.invalid}'),
                                  Text('${e.correct}')
                                ],
                              ))
                          .toList()
                  ],
                ),
              );
            },
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed:
            // If not yet listening for speech start, otherwise stop
            _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        backgroundColor:
            _speechToText.isNotListening ? Colors.blue : Colors.red,
        child: Icon(Icons.mic),
      ),
    );
  }

  List<InvalidPhrase>? validatePhrase(Phrase phrase, String recorded) {
    List<String> phraseList = phrase.content!
        .toLowerCase()
        .replaceAll(",", "")
        .replaceAll(".", "")
        .replaceAll("?", " ")
        .split(" ");
    List<String> recordedList = recorded
        .toLowerCase()
        .replaceAll(",", "")
        .replaceAll(".", "")
        .replaceAll("?", " ")
        .split(" ");

    List<InvalidPhrase> erradas = [];
    recordedList.asMap().forEach((index, String element) {
      if (element.compareTo(phraseList[index]) != 0) {
        erradas
            .add(InvalidPhrase(invalid: element, correct: phraseList[index]));
      }
    });

    setState(() {
      invalidas = [];
      invalidas = erradas;
      if (erradas.isEmpty) {
        phrases[currentIndex].correct = 1;
      } else {
        phrases[currentIndex].correct = 0;
      }
    });

    return erradas;
  }
}
