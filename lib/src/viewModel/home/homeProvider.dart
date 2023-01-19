// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:ssc/models/home/userInformationsDashboard.dart';
import 'package:ssc/src/model/home/homeRepository.dart';

import '../../../models/home/payOffFinancialInformations.dart';

class HomeProvider extends ChangeNotifier {

  HomeRepository homeRepository = HomeRepository();
  bool showFloatingButton = true;
  bool isEditQuickAccessActive = false;
  bool isQuickAccessListEmpty = false;
  bool isSplashScreenLoading = false;

  Future<UserInformation> getStatistics() async{
    return await homeRepository.getStatisticsService();
  }

  Future<PayOffFinancialInformation> getAmountToBePaid() async{
    return await homeRepository.getAmountToBePaidService();
  }

  void notifyMe() {
    notifyListeners();
  }
}