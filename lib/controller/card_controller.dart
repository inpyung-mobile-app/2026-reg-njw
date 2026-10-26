import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:untitled/controller/soul_controller.dart';
import 'package:untitled/model/tarot_card.dart';

class CardController {
  static List<TarotCard> loveList = [];

  static List<TarotCard> fruitList = [];

  static int selected = 0;
  static TarotType type = .love;

  static Future<void> getLoveList() async {
    final String load = await rootBundle.loadString('assets/data/loves_tarot_cards_data.json');
    final List<dynamic> json = jsonDecode(load);

    loveList = json.map((e) => TarotCard.fromJson(e),).toList();
  }

  static Future<void> getFruitList() async {
    final String load = await rootBundle.loadString('assets/data/fruit_tarot_cards_data.json');
    final List<dynamic> json = jsonDecode(load);

    fruitList = json.map((e) => TarotCard.fromJson(e),).toList();
  }
}