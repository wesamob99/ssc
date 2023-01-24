// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';

class MainProvider extends ChangeNotifier {

  TextEditingController searchController = TextEditingController();

  void notifyMe() {
    notifyListeners();
  }
}