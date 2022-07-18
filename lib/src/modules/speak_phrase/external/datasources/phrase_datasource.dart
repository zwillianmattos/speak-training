import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:uno/uno.dart';

import '../../domain/errors/errors.dart';
import '../../infra/datasources/phrase_datasource.dart';

class PhraseDataSource implements IPhrasesDatasource {
  final Uno uno;

  PhraseDataSource(this.uno);

  @override
  Future<List> getPhrases() async {
    try {
      final String response =
          await rootBundle.loadString('assets/data/common_expressions.json');
      final List<dynamic> data = await json.decode(response);
      return data;
    } catch (e, s) {
      throw DatasourcePhraseException(e.toString(), s);
    }
  }
}
