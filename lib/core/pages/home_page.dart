import 'package:falandoingles/core/enum/phrase_category.dart';
import 'package:falandoingles/core/pages/list_phrases_page.dart';
import 'package:falandoingles/core/pages/pratice_page.dart';
import 'package:falandoingles/core/themes/app_theme.dart';
import 'package:falandoingles/core/widgets/app_bar_widget.dart';
import 'package:falandoingles/core/widgets/card_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PhraseCategory phraseCategory = PhraseCategory.common_expressions;

  @override
  Widget build(BuildContext context) {
    Widget getSearchBarUI() {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              height: 64,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppTheme.nearlyWhite,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(13.0),
                      bottomLeft: Radius.circular(13.0),
                      topLeft: Radius.circular(13.0),
                      topRight: Radius.circular(13.0),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: TextFormField(
                            style: const TextStyle(
                              fontFamily: 'WorkSans',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppTheme.appBar,
                            ),
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: 'Search for course',
                              border: InputBorder.none,
                              helperStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppTheme.appBarBorder,
                              ),
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                letterSpacing: 0.2,
                                color: AppTheme.appBarBorder,
                              ),
                            ),
                            onEditingComplete: () {},
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 60,
                        height: 60,
                        child: Icon(Icons.search, color: AppTheme.appBarBorder),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const Expanded(
              child: SizedBox(),
            )
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.nearlyWhite,
      body: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          const AppBarWidget(),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    // getSearchBarUI(),
                    // getCategoryUI(),
                    Flexible(
                      child: getPopularCourseUI(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getCategoryUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 8.0, left: 18, right: 16),
          child: Text(
            'Category',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 0.27,
              color: AppTheme.darkerText,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            children: <Widget>[
              getButtonUI(PhraseCategory.common_expressions,
                  PhraseCategory == PhraseCategory.common_expressions),
              const SizedBox(
                width: 16,
              ),
              getButtonUI(PhraseCategory.communication_difficulties,
                  PhraseCategory == PhraseCategory.communication_difficulties),
              const SizedBox(
                width: 16,
              ),
              getButtonUI(PhraseCategory.dining,
                  PhraseCategory == PhraseCategory.dining),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        // CategoryListView(
        //   callBack: () {
        //     moveTo();
        //   },
        // ),
      ],
    );
  }

  Widget getPopularCourseUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Phrases pratice',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 0.27,
              color: AppTheme.darkerText,
            ),
          ),
          Flexible(
            child: CardListViewWidget(
              callBack: () {
                moveTo();
              },
            ),
          )
        ],
      ),
    );
  }

  void moveTo() {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => PraticePage(
          phraseCategory: phraseCategory,
        ),
      ),
    );
  }

  Widget getButtonUI(PhraseCategory phraseCategoryData, bool isSelected) {
    String txt = '';
    if (PhraseCategory.common_expressions == phraseCategoryData) {
      txt = 'Common Expressions';
    }
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: isSelected ? AppTheme.nearlyBlue : AppTheme.nearlyWhite,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            border: Border.all(color: AppTheme.nearlyBlue)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            onTap: () {
              setState(() {
                phraseCategory = phraseCategoryData;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 18, right: 18),
              child: Center(
                child: Text(
                  txt,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.27,
                    color:
                        isSelected ? AppTheme.nearlyWhite : AppTheme.nearlyBlue,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
