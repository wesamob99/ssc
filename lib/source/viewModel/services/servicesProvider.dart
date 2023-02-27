// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:ssc/source/model/services/servicesRepository.dart';

import '../../../models/login/countries.dart';
import '../../../models/accountSettings/userProfileData.dart';

class ServicesProvider extends ChangeNotifier {

  ServicesRepository servicesRepository = ServicesRepository();
  int selectedServiceRate = -1;
  bool isMobileNumberUpdated = false;
  bool isLoading = false;

  bool isModalLoading = false;
  bool isNationalIdValid = false;
  List dependentsDocuments;
  var dependentInfo;

  /// this variable used in every service, the get API called when any service open return result and we save that result in this variable
  /// check the servicesListConstants.dart to see service's API
  var result;
  ///
  int stepNumber = 1;
  String selectedInjuredType = 'occupationalDisease';
  TextEditingController monthlyInstallmentController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController pinPutCodeController = TextEditingController();
  bool pinPutFilled = false;
  List<Countries> countries = [];

  /// documents screen controllers *****************
  int documentsScreensStepNumber = 1;
  List optionalDocumentsCheckBox = [];
  List selectedOptionalDocuments = [];
  ///
  int documentIndex = 0;
  List mandatoryDocuments = [];
  List optionalDocuments = [];
  Map uploadedFiles = {
    "mandatory": [],
    "optional": [],
  };
  /// **********************************************

  Future<UserProfileData> getAccountData() async{
    return await servicesRepository.getAccountDataService();
  }

  Future getInquiryInsuredInformation() async{
    return await servicesRepository.getInquiryInsuredInformationService();
  }

  Future getInsuredInformationReport(value) async{
    return await servicesRepository.getInsuredInformationReportService(value);
  }

  Future getActivePayment(String serviceType, String nat) async{
    return await servicesRepository.getActivePaymentService(serviceType, nat);
  }

  Future getRequiredDocuments(data, serviceNo) async{
    return await servicesRepository.getRequiredDocumentsService(data, serviceNo);
  }

  Future saveFile(file) async{
    return await servicesRepository.saveFileService(file);
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

  Future addNewDependent(String natID) async{
    return await servicesRepository.addNewDependentService(natID);
  }

  Future submitOptionSubIncrement(int selectedRate, double newSalary) async{
    return await servicesRepository.submitOptionSubIncrementService(selectedRate, newSalary);
  }

  Future updateUserMobileNumberSendOTP(String newNumber) async{
    return await servicesRepository.updateUserMobileNumberSendOTPService(newNumber);
  }

  Future updateUserMobileNumberCheckOTP(String code) async{
    return await servicesRepository.updateUserMobileNumberCheckOTPService(code);
  }

  Future updateUserEmailSendOTP(String email, int firstTime) async{
    final response = await servicesRepository.updateUserEmailSendOTPService(email, firstTime);
    return response;
  }

  Future updateUserEmailCheckOTP(String email, int code, int firstTime) async{
    final response = await servicesRepository.updateUserEmailCheckOTPService(email, code, firstTime);
    return response;
  }

  Future setEarlyRetirementApplication(docs, Map paymentInfo, int authorizedToSign, int wantInsurance) async{
    return await servicesRepository.setEarlyRetirementApplicationService(result, docs, paymentInfo, authorizedToSign, wantInsurance);
  }

  Future checkDocumentDependent(String gender) async{
    return await servicesRepository.checkDocumentDependentService(gender);
  }

  Future getPensionsBasicInformations() async{
    return await servicesRepository.getPensionsBasicInformationsService();
  }

  Future getDependentInfo(String id) async{
    return await servicesRepository.getDependentInfoService(id);
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