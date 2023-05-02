// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ssc/source/model/services/servicesRepository.dart';

import '../../../infrastructure/userConfig.dart';
import '../../../models/login/countries.dart';
import '../../../models/accountSettings/userProfileData.dart';
import '../../../utilities/util.dart';

class ServicesProvider extends ChangeNotifier {

  ServicesRepository servicesRepository = ServicesRepository();
  int selectedServiceRate = -1;
  bool isMobileNumberUpdated = false;
  bool isLoading = false;

  bool isModalLoading = false;
  bool isNationalIdValid = false;
  List dependentsDocuments;
  var dependentInfo;
  var heirsInfo;
  var deadPersonInfo;
  Map penDeath;

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

  /// payments screen controllers *****************
  TextEditingController bankNameController = TextEditingController();
  TextEditingController bankBranchController = TextEditingController();
  TextEditingController bankAddressController = TextEditingController();
  TextEditingController accountNoController = TextEditingController();
  TextEditingController swiftCodeController = TextEditingController();
  TextEditingController paymentMobileNumberController = TextEditingController();
  SelectedListItem selectedPaymentCountry;
  Map selectedActivePayment;
  String selectedInsideOutsideJordan = 'insideJordan';
  List activePayment = [];
  /// **********************************************

  double currentLoanValue = 1;
  double currentNumberOfInstallments = 1;
  double currentFinancialCommitment = 0;

  TextEditingController reasonController = TextEditingController();


  Future<UserProfileData> getAccountData() async{
    return await servicesRepository.getAccountDataService();
  }

  Future getInquiryInsuredInformation() async{
    return await servicesRepository.getInquiryInsuredInformationService();
  }

  Future getInsuredInformationReport(value) async{
    await servicesRepository.getInsuredInformationReportService(value).then((value) async {
      await downloadAndOpenPDF(value, 'تبليغ قرار التقاعد').whenComplete(() {
        if (kDebugMode) {
          print('completed');
        }
      });
    });
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

  Future setEarlyRetirementApplication(docs, Map paymentInfo, int authorizedToSign, int wantInsurance, int serviceType) async{
    return await servicesRepository.setEarlyRetirementApplicationService(result, docs, paymentInfo, authorizedToSign, wantInsurance, serviceType);
  }

  Future setDeceasedRetirementApplication(docs, deathPlace) async{
    return await servicesRepository.setDeceasedRetirementApplicationService(result, docs, deadPersonInfo, deathPlace);
  }

  Future checkDocumentDependent(List dependents) async{
    return await servicesRepository.checkDocumentDependentService(dependents);
  }

  Future deadPersonGetDetails(Map<String, dynamic> data) async{
    return await servicesRepository.deadPersonGetDetailsService(data);
  }

  Future guardianGetDetails(String natNo, int nationality, String cardNo, {String dateOfBirth = 'undefined'}) async{
    return await servicesRepository.guardianGetDetailsService(natNo, nationality, cardNo, dateOfBirth);
  }

  Future penDeathLookup() async{
    penDeath = await servicesRepository.penDeathLookup();
    return penDeath;
  }

  Future getPensionsBasicInformations() async{
    return await servicesRepository.getPensionsBasicInformationsService();
  }

  Future getDependentInfo(String id) async{
    return await servicesRepository.getDependentInfoService(id);
  }

  Future getHeirsInfo(String heirsNatNo) async{
    return await servicesRepository.getHeirsInfoService(heirsNatNo, deadPersonInfo['cur_getdata'][0][0]['NAT_NO'].toString());
  }

  Future loanCalculation(double currentFinancialCommitment, double currentLoanValue, currentNumberOfInstallments, selectedLoanCategory, selectedLoanType) async{
    int piFlag = result['p_per_info'][0][0]['DUAL_FLG'];
    double payNet = double.tryParse(result[selectedLoanType == 'heirLoan' ? 'P_DEAD_LOAN' : 'p_per_info'][0][0]['NET_PAY'].toString());
    double payTot = double.tryParse(result[selectedLoanType == 'heirLoan' ? 'P_DEAD_LOAN' : 'p_per_info'][0][0]['TOT_PAY'].toString());
    String loanType = result['P_LAON_TYPE'][0].where((element) => (UserConfig.instance.isLanguageEnglish()
        ? element['DESC_EN'] : element['DESC_AR']) == selectedLoanCategory).first['COD'];

    return await servicesRepository.loanCalculationService(piFlag, payNet, payTot, currentFinancialCommitment, currentLoanValue, currentNumberOfInstallments, loanType);
  }

  Future getPensionPaymentSP(String year) async{
    return await servicesRepository.getPensionPaymentSPService(year);
  }

  Future setRetirementLoanApplication(docs, paymentInfo, typeOfAdvance, loanType, loanResultInfo, selectedLoanType, int serviceType) async{
    return await servicesRepository.setRetirementLoanApplicationService(result, docs, paymentInfo, typeOfAdvance, loanType, loanResultInfo, currentLoanValue, currentNumberOfInstallments, currentFinancialCommitment, selectedLoanType, serviceType);
  }

  Future getDecision() async{
    return await servicesRepository.getDecisionService(result['V_ID']);
  }

  Future getRetirementDecisionPDFFileDetails(dynamic folderName, context) async{
    var res;
    await servicesRepository.getRetirementDecisionPDFFileDetailsService(folderName).then((value) async {
      res = await downloadPDF(value, getTranslated('تبليغ قرار التقاعد', context)).whenComplete(() {
        if (kDebugMode) {
          print('completed');
        }
      });
    });
    return res;
  }

  Future getDecExistence() async{
    return await servicesRepository.getDecExistence();
  }

  Future getPensionSalaryDetails(String month, String year, int pType) async{
    return await servicesRepository.getPensionSalaryDetailsService(month, year, pType);
  }

  Future penUpdateSeen() async{
    return await servicesRepository.penUpdateSeenService(result['V_ID'].toString());
  }

  Future sendDecOtp() async{
    return await servicesRepository.sendDecOtpService(result['V_ID'].toString());
  }

  Future getOnePaymentReason() async{
    return await servicesRepository.getOnePaymentReasonService();
  }

  Future getOnePaymentReasonValidate(reasonType) async{
    return await servicesRepository.getOnePaymentReasonValidateService(reasonType);
  }

  Future getOneTimeRefundInquiry() async{
    return await servicesRepository.getOneTimeRefundInquiryService();
  }

  Future submitIssuingRetirementDecision(int pCode, int pActionTaken, String pActionJustify) async{
    return await servicesRepository.submitIssuingRetirementDecisionService(result['V_ID'], pCode, pActionTaken, pActionJustify);
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