import 'package:falandoingles/core/enum/phrase_category.dart';
import 'package:falandoingles/core/pages/list_phrases_page.dart';
import 'package:flutter/material.dart';

class SelectCategoryPhrasePage extends StatefulWidget {
  const SelectCategoryPhrasePage({Key? key}) : super(key: key);

  @override
  _SelectCategoryPhrasePageState createState() =>
      _SelectCategoryPhrasePageState();
}

class _SelectCategoryPhrasePageState extends State<SelectCategoryPhrasePage> {
  List<PhraseCategory> phraseCategory = [PhraseCategory.common_expressions];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select categories'),
      ),
      body: ListView(
        children: phraseCategory
            .map((e) => Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ListPhrasesPage(
                                phraseCategory: e,
                              )));
                    },
                    title: const Text("Common Expressions"),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
