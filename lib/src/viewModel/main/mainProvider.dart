import 'package:flutter/cupertino.dart';

class MainProvider extends ChangeNotifier {

  void notifyMe() {
    notifyListeners();
  }
}