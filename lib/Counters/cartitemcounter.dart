import 'package:flutter/foundation.dart';
import 'package:wsy/Config/config.dart';

class CartItemCounter extends ChangeNotifier {
  int _counter =
      wsy.sharedPreferences!.getStringList(wsy.userCartList)!.length - 1;

  int get count => _counter;

  Future<void> displayResult() async {
    _counter =
        wsy.sharedPreferences!.getStringList(wsy.userCartList)!.length - 1;

    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
