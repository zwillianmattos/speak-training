import 'package:falandoingles/core/enum/phrase_category.dart';
import 'package:falandoingles/core/model/invalid_phrase.dart';
import 'package:falandoingles/core/model/phrase.dart';
import 'package:falandoingles/core/repositories/common_expressions.dart';
import 'package:falandoingles/core/themes/app_theme.dart';
import 'package:falandoingles/core/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class PraticePage extends StatefulWidget {
  final PhraseCategory phraseCategory;
  const PraticePage({Key? key, required this.phraseCategory}) : super(key: key);

  @override
  State<PraticePage> createState() => _PraticePageState();
}

class _PraticePageState extends State<PraticePage> {
  final FlutterTts flutterTts = FlutterTts();
  final SpeechToText speechToText = SpeechToText();

  late List<Phrase> phrases = [];
  late List<InvalidPhrase>? invalidas = [];

  bool isLoading = false;

  int currentIndex = 0;
  bool _speechEnabled = false;

  String falando = "";

  RichText richText = RichText(text: const TextSpan(text: ""));

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _loadData();
    _initTts();
  }

  Future _speak(String key) async {
    var result = await flutterTts.speak(key);
  }

  Future _stop() async {
    var result = await flutterTts.stop();
  }

  void _initSpeech() async {
    _speechEnabled = await speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    falando = "";
    await speechToText.listen(onResult: _onSpeechResult, localeId: 'en_US');
    setState(() {});
  }

  void _stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      richText = RichText(text: TextSpan(text: ""));
      var errados =
          validatePhrase(phrases[currentIndex], result.recognizedWords);

      List<TextSpan>? span = [];

      List<String> recordedList = result.recognizedWords
          .toLowerCase()
          .replaceAll(",", "")
          .replaceAll(".", "")
          .replaceAll("?", " ")
          .split(" ");

      recordedList.asMap().forEach((index, String element) {
        print(
            "$element - ${errados![index].correct.toString()} - ${result.recognizedWords}");

        if (element.compareTo(errados[index].correct.toString()) != 0) {
          print("errado");
          span.add(TextSpan(
              text: errados[index].correct.toString().toUpperCase(),
              style: const TextStyle(
                  color: Colors.red,
                  fontSize: 32,
                  fontWeight: FontWeight.bold)));
        } else {
          print("entrou");
          span.add(TextSpan(
              text: element.toUpperCase(),
              style: const TextStyle(
                  color: Colors.green,
                  fontSize: 32,
                  fontWeight: FontWeight.bold)));
        }
      });

      richText = RichText(
          text: TextSpan(
              text: "",
              children: span.toList(),
              style:
                  const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)));
    });
  }

  _initTts() async {
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
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

    print(erradas);
    return erradas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pratice'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    decoration: const BoxDecoration(
                      color: AppTheme.grey,
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    padding: EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${phrases[0].content}",
                          style: TextStyle(color: AppTheme.nearlyWhite),
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 15,
                ),
                Stack(
                  children: [
                    Text(
                      "${phrases[0].content?.toUpperCase()}",
                      style: const TextStyle(
                          color: AppTheme.grey,
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    ),
                    richText
                    // Text(
                    //   falando.toUpperCase(),
                    //   style: const TextStyle(
                    //       color: AppTheme.nearlyBlue,
                    //       fontSize: 32,
                    //       fontWeight: FontWeight.bold),
                    // ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ButtonWidget(
                      enabled: speechToText.isNotListening ? true : false,
                      callBack: () {
                        _speak("${phrases[currentIndex].content}");
                      },
                      content: const Icon(
                        Icons.volume_up,
                        color: AppTheme.nearlyWhite,
                      ),
                    ),
                    ButtonWidget(
                      color: speechToText.isNotListening
                          ? AppTheme.nearlyBlue
                          : Colors.red,
                      callBack: speechToText.isNotListening
                          ? _startListening
                          : _stopListening,
                      content: const Icon(
                        Icons.mic_sharp,
                        color: AppTheme.nearlyWhite,
                      ),
                    ),
                  ],
                )
              ],
            ),
    );
  }
}
