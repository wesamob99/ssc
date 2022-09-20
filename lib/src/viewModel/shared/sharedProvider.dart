import 'package:flutter/cupertino.dart';

class SharedProvider extends ChangeNotifier {

  void notifyMe() {
    notifyListeners();
  }
}
