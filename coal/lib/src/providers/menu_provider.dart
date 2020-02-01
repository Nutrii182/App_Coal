
import 'dart:convert';

import 'package:flutter/services.dart';

class _MenuProvider {

  List<dynamic> options = [];

  Future<List<dynamic>> cargarData() async {

    final resp = await rootBundle.loadString('data/menu_opts.json');

    Map dataMap = json.decode(resp);
    options = dataMap['routes'];

    return options;
  }
}

final menuProvider = new _MenuProvider();