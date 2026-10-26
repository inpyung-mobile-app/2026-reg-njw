import 'package:flutter/cupertino.dart';
import 'package:untitled/model/user.dart';

class FlowController {
  static ValueNotifier<User> user = ValueNotifier(User.empty());
  static ValueNotifier<int> pageIndex = ValueNotifier(0);
  static int? backIndex;

  static Future<void> back() async {
    pageIndex.value = backIndex!;
    await Future.delayed(Duration(milliseconds: 200));
    backIndex = null;
  }
}