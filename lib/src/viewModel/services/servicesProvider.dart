// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:ssc/src/model/services/servicesRepository.dart';

import '../../../models/login/countries.dart';
import '../../../models/profile/userProfileData.dart';

class ServicesProvider extends ChangeNotifier {

  ServicesRepository servicesRepository = ServicesRepository();
  int selectedServiceRate = -1;
  bool isMobileNumberUpdated = false;
  bool isLoading = false;
  // ignore: prefer_typing_uninitialized_variables
  var result;
  TextEditingController monthlyInstallmentController = TextEditingController();
  int stepNumber = 1;
  String selectedInjuredType = 'occupationalDisease';
  TextEditingController mobileNumberController = TextEditingController();
  List<Countries> countries = [];

  Future<UserProfileData> getAccountData() async{
    return await servicesRepository.getAccountDataService();
  }

  Future optionalSubGetDetail() async{
    return await servicesRepository.optionalSubGetDetailService();
  }

  Future optionalSubInsertNew(double monthlyPay, double appliedSalary ,int submissionType, int selectedNumberOfIncrements, int selectedMaxPerForInc, String percentDecreaseVal) async{
    return await servicesRepository.optionalSubInsertNewService(result['cur_getdata'][0][0], monthlyPay, appliedSalary , submissionType, selectedNumberOfIncrements, selectedMaxPerForInc, percentDecreaseVal);
  }

  Future optionalSubFirstInsertNew(double monthlyPay, double salaryRequest ,int submissionType) async{
    return await servicesRepository.optionalSubFirstInsertNewService(result['cur_getdata'][0][0], monthlyPay, salaryRequest , submissionType);
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
