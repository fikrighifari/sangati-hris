// ignore_for_file: avoid_printglutton, avoid_print

import 'package:glutton/glutton.dart';

class LocalStorageService {
  static Future<bool> save(String key, value) async {
    try {
      return await Glutton.eat(key, value);
    } on GluttonFormatException catch (e) {
      print(e.message);
      return false;
    }
  }

  static Future<dynamic> load(String key) async {
    return await Glutton.vomit(key);
  }

  static Future<bool> remove(String key) async {
    return await Glutton.digest(key);
  }

  static Future<bool> check(String key) async {
    return await Glutton.have(key);
  }

  static Future<bool> deleteAll() async {
    return await Glutton.flush();
  }
}
