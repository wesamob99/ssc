import 'package:flutter/cupertino.dart';
import 'package:ssc/src/model/home/homeRepository.dart';

class HomeProvider extends ChangeNotifier {

  HomeRepository homeRepository = HomeRepository();

  Future getStatistics() async{
    return await homeRepository.getStatisticsService();
  }

  void notifyMe() {
    notifyListeners();
  }
}