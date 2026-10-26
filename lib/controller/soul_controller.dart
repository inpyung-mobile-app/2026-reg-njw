import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/model/tarot_card.dart';

class SoulController {
  static ValueNotifier<int> moon = ValueNotifier(10);
  static late SharedPreferences prefs;

  static List<TarotCard> soulList = [];
  static ValueNotifier<DateTime?> birth = ValueNotifier(null);
  static int selected = 0;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();

    await getMoon();
    await getSoulList();
  }

  static Future<void> getMoon() async {
    moon.value = prefs.getInt('moon') ?? 10;
  }

  static Future<void> saveMoon(int inputMoon) async {
    final count = prefs.getInt('moon') ?? 10;
    await prefs.setInt('moon', inputMoon + count < 0 ? 0 : inputMoon + count);
  }

  static Future<void> massage(String text) async {
    await MethodChannel('toast').invokeMethod('message', {'text': text});
  }

  static Future<void> getSoulList() async {
    final String load = await rootBundle.loadString('assets/data/soul_cards_data.json');
    final List<dynamic> json = jsonDecode(load);

    soulList = json.map((e) => TarotCard.fromJson(e),).toList();
  }
}

enum TarotType {
  fruit,
  love
}
