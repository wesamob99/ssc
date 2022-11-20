// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ssc/src/model/services/servicesRepository.dart';

import '../../../models/login/countries.dart';
import '../../../models/profile/userProfileData.dart';

class ServicesProvider extends ChangeNotifier {

  ServicesRepository servicesRepository = ServicesRepository();
  UserProfileData userProfileData = UserProfileData();
  int selectedServiceRate = -1;

  TextEditingController monthlyInstallmentController = TextEditingController();

  /// workInjuryComplaint
  int stepNumber = 1;
  String selectedInjuredType = 'occupationalDisease';
  TextEditingController mobileNumberController = TextEditingController();
  List<Countries> countries = [];

  /// workInjuryComplaint
  Future<UserProfileData> getAccountData() async{
    userProfileData = await servicesRepository.getAccountDataService();
    notifyMe();
    return userProfileData;
  }

  Future<void> readCountriesJson() async {
    countries = [];
    final String response = await rootBundle.loadString('assets/jsonFiles/countries.json');
    countries = countriesFromJson(response);
    notifyListeners();
    if (kDebugMode) {
      print(countries);
    }
  }

  void notifyMe() {
    notifyListeners();
  }
}
