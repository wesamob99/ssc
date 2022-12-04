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
  int selectedServiceRate = -1;
  bool isMobileNumberUpdated = false;
  bool isLoading = false;
  CurGetdatum2 datum = CurGetdatum2();
  // ignore: prefer_typing_uninitialized_variables
  var result;

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

  Future optionalSubInsertNew(double monthlyPay, double appliedSalary ,int submissionType, int selectedNumberOfIncrements, int selectedMaxPerForInc) async{
    return await servicesRepository.optionalSubInsertNewService(result['cur_getdata'][0][0], monthlyPay, appliedSalary , submissionType, selectedNumberOfIncrements, selectedMaxPerForInc);
  }

  Future optionalSubFirstInsertNew(double monthlyPay, double appliedSalary ,int submissionType, int selectedNumberOfIncrements, int selectedMaxPerForInc) async{
    return await servicesRepository.optionalSubFirstInsertNewService(result['cur_getdata'][0][0], monthlyPay, appliedSalary , submissionType, selectedNumberOfIncrements, selectedMaxPerForInc);
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
