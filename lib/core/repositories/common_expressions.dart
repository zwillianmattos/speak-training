import 'dart:convert';

import 'package:falandoingles/core/model/phrase.dart';
import 'package:flutter/services.dart';

import '../enum/phrase_category.dart';
import '../model/invalid_phrase.dart';

Future<List<Phrase>> getCommonExpressions(PhraseCategory phraseCategory) async {
  List<Phrase> items = [];
  final String response =
      await rootBundle.loadString('assets/data/${phraseCategory.name}.json');
  final List<dynamic> data = await json.decode(response);

  for (var e in data) {
    items.add(Phrase.fromJson(e));
  }

  return items;
}
