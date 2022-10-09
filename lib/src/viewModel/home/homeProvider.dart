// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:ssc/models/home/userInformationsDashboard.dart';
import 'package:ssc/src/model/home/homeRepository.dart';

class HomeProvider extends ChangeNotifier {

  HomeRepository homeRepository = HomeRepository();
  bool showFloatingButton = true;

  Future<UserInformation> getStatistics() async{
    return await homeRepository.getStatisticsService();
  }

  void notifyMe() {
    notifyListeners();
  }
}