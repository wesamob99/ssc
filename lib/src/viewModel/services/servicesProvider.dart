// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:ssc/src/model/services/servicesRepository.dart';

import '../../../models/login/countries.dart';
import '../../../models/accountSettings/userProfileData.dart';

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
  TextEditingController pinPutCodeController = TextEditingController();
  bool pinPutFilled = false;
  List<Countries> countries = [];

  Future<UserProfileData> getAccountData() async{
    return await servicesRepository.getAccountDataService();
  }

  Future getRequiredDocuments() async{
    return await servicesRepository.getRequiredDocumentsService(result);
  }

  Future<UserProfileData> optionalSubIncGetDetailNew() async{
    return await servicesRepository.optionalSubIncGetDetailNewService();
  }

  Future optionalSubGetDetail() async{
    return await servicesRepository.optionalSubGetDetailService();
  }

  Future optionalSubInsertNew(double monthlyPay, int firstOptionalSub, double appliedSalary ,int submissionType, int selectedNumberOfIncrements, int selectedMaxPerForInc, String percentDecreaseVal, String selectedMonth) async{
    return await servicesRepository.optionalSubInsertNewService(result['cur_getdata'][0][0], firstOptionalSub, monthlyPay, appliedSalary , submissionType, selectedNumberOfIncrements, selectedMaxPerForInc, percentDecreaseVal, selectedMonth);
  }

  Future optionalSubFirstInsertNew(double monthlyPay, double salaryRequest ,int submissionType) async{
    return await servicesRepository.optionalSubFirstInsertNewService(result['cur_getdata'][0][0], monthlyPay, salaryRequest , submissionType);
  }

  Future deleteDependent(int id) async{
    return await servicesRepository.deleteDependentService(id);
  }

  Future updateUserMobileNumberSendOTP(String newNumber) async{
    return await servicesRepository.updateUserMobileNumberSendOTPService(newNumber);
  }

  Future submitOptionSubIncrement(int selectedRate, double newSalary) async{
    return await servicesRepository.submitOptionSubIncrementService(selectedRate, newSalary);
  }

  Future updateUserMobileNumberCheckOTP(String code) async{
    return await servicesRepository.updateUserMobileNumberCheckOTPService(code);
  }

  Future setEarlyRetirementApplication() async{
    return await servicesRepository.setEarlyRetirementApplicationService(result);
  }

  Future getPensionsBasicInformations() async{
    return await servicesRepository.getPensionsBasicInformationsService();
  }

  Future getPensionPaymentSP(String year) async{
    return await servicesRepository.getPensionPaymentSPService(year);
  }

  Future getEarlyRetirement() async{
    return await servicesRepository.getEarlyRetirementService();
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
