// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:ssc/src/model/services/servicesRepository.dart';

import '../../../models/login/countries.dart';
import '../../../models/profile/userProfileData.dart';
import '../../../models/services/optionalSubGetDetail.dart';

class ServicesProvider extends ChangeNotifier {

  ServicesRepository servicesRepository = ServicesRepository();
  UserProfileData userProfileData = UserProfileData();
  OptionalSubGetDetail optionalSubDetail = OptionalSubGetDetail();
  int selectedServiceRate = -1;
  int isFirstOptionalSub = -1;
  bool isMobileNumberUpdated = false;

  TextEditingController monthlyInstallmentController = TextEditingController();

  /// workInjuryComplaint
  int stepNumber = 1;
  String selectedInjuredType = 'occupationalDisease';
  TextEditingController mobileNumberController = TextEditingController();
  List<Countries> countries = [];

  // deleted
  // Future<UserProfileData> getAccountData() async{
  //   userProfileData = await servicesRepository.getAccountDataService();
  //   notifyMe();
  //   return userProfileData;
  // }

  Future optionalSubGetDetail() async{
    return await servicesRepository.optionalSubGetDetailService();
  }

  Future optionalSubInsertNew() async{
    return await servicesRepository.optionalSubInsertNewService(optionalSubDetail.curGetdata[0][0]);
  }

  Future optionalSubFirstInsertNew() async{
    return await servicesRepository.optionalSubInsertNewService(optionalSubDetail.curGetdata[0][0]);
  }

  Future<void> readCountriesJson() async {
    countries = [];
    final String response = await rootBundle.loadString('assets/jsonFiles/countries.json');
    countries = countriesFromJson(response);
    notifyListeners();
  }

  void notifyMe() {
    notifyListeners();
  }
}
