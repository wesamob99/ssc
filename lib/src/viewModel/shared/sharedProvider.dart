// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';

class SharedProvider extends ChangeNotifier {

  void notifyMe() {
    notifyListeners();
  }
}
