import '../../modules/speak_phrase/domain/entities/phrase.dart';

List? validatePhrase(Phrase phrase, String recorded) {
  List<String> correct = phrase.content!.split(" ");
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

  List<dynamic> letras = [];

  var maxVerify = phraseList.length;
  recordedList.asMap().forEach((index, String element) {
    if (index < maxVerify) {
      if (element.compareTo(phraseList[index]) != 0) {
        letras.add(
            <String, String?>{'invalid': element, 'correct': correct[index]});
      } else {
        letras
            .add(<String, String?>{'invalid': '', 'correct': correct[index]});
      }
    }
  });

  return letras;
}
