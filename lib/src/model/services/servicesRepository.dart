// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:ssc/infrastructure/userSecuredStorage.dart';

import '../../../infrastructure/HTTPClientContract.dart';
import '../../../models/services/pensionPaymentModel.dart';

class ServicesRepository{

  Future getAccountDataService() async {
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
    String internalKey = userSecuredStorage.insuranceNumber.toString();
    var response = await HTTPClientContract.instance.getHTTP('/individuals/GET_INDIVIDUALUSERINFOSP?PIINSURANCENO=$internalKey');
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.toString());
    }
    return null;
  }

  Future getRequiredDocumentsService(result) async {
    var data = {"params":{"Data":"{\"PAYMENT_METHOD\":${result['P_Result'][0][0]['PAYMENT_METHOD']},\"BANK_LOCATION\":${result['P_Result'][0][0]['BANK_LOCATION']},"
        "\"BRANCH_ID\":${result['P_Result'][0][0]['BRANCH_ID']},\"BRANCH_NAME\":${result['P_Result'][0][0]['BRANCH_NAME']},\"BANK_ID\":${result['P_Result'][0][0]['BANK_ID']},"
        "\"BANK_NAME\":${result['P_Result'][0][0]['BANK_NAME']},\"ACCOUNT_NAME\":${result['P_Result'][0][0]['ACCOUNT_NAME']},\"PAYMENT_COUNTRY\":${result['P_Result'][0][0]['PAYMENT_COUNTRY']},"
        "\"PAYMENT_COUNTRY_CODE\":${result['P_Result'][0][0]['PAYMENT_COUNTRY_CODE']},\"PAYMENT_PHONE\":${result['P_Result'][0][0]['PAYMENT_PHONE']},"
        "\"IFSC\":${result['P_Result'][0][0]['IFSC']},\"SWIFT_CODE\":${result['P_Result'][0][0]['SWIFT_CODE'] ?? ''}\"\",\"BANK_DETAILS\":${result['P_Result'][0][0]['SWIFT_CODE'] ?? ''}\"\",\"IBAN\":null,"
        "\"CASH_BANK_ID\":${result['P_Result'][0][0]['CASH_BANK_ID']},\"REP_NATIONALITY\":${result['P_Result'][0][0]['REP_NATIONALITY'] ?? ''}\"\","
        "\"REP_NATIONAL_NO\":${result['P_Result'][0][0]['REP_NATIONAL_NO'] ?? ''}\"\",\"REP_NAME\":${result['P_Result'][0][0]['REP_NAME'] ?? ''}\"\",\"WALLET_TYPE\":${result['P_Result'][0][0]['WALLET_TYPE']},\"WALLET_OTP_VERIVIED\":${result['P_Result'][0][0]['WALLET_OTP_VERIVIED']},"
        "\"WALLET_OTP\":${result['P_Result'][0][0]['WALLET_OTP']},\"WALLET_PHONE\":${result['P_Result'][0][0]['WALLET_PHONE']},"
        "\"WALLET_PHONE_VERIVIED\":${result['P_Result'][0][0]['WALLET_PHONE_VERIVIED']},\"WALLET_PASSPORT_NUMBER\":${result['P_Result'][0][0]['WALLET_PASSPORT_NUMBER']},\"PEN_IBAN\":${result['P_Result'][0][0]['PEN_IBAN']},"
        "\"SECNO\":${result['p_per_info'][0][0]['SECNO']},\"NAT_DESC\":\"${result['P_Result'][0][0]['NAT_DESC']}\",\"NAT\":${result['P_Result'][0][0]['NAT']},"
        "\"NAT_NO\":${result['P_Result'][0][0]['NAT_NO']},\"PERS_NO\":${result['P_Result'][0][0]['PERS_NO']},\"LAST_EST_NAME\":\"${result['P_Result'][0][0]['LAST_EST_NAME']}\",\"NAME1\":\"${result['p_per_info'][0][0]['NAME1']}\",\"NAME2\":\"${result['p_per_info'][0][0]['NAME2']}\",\"NAME3\":\"${result['p_per_info'][0][0]['NAME3']}\","
        "\"NAME4\":\"${result['p_per_info'][0][0]['NAME4']}\",\"FULL_NAME_EN\":\"${result['p_per_info'][0][0]['FULL_NAME_EN']}\",\"EMAIL\":\"${result['p_per_info'][0][0]['EMAIL']}\",\"MOBILE\":${result['p_per_info'][0][0]['MOBILE']},\"INTERNATIONAL_CODE\":${result['p_per_info'][0][0]['INTERNATIONAL_CODE']},\"INSURED_ADDRESS\":${result['P_Result'][0][0]['INSURED_ADDRESS']},"
        "\"MARITAL_STATUS\":${result['P_Result'][0][0]['MARITAL_STATUS']},\"REGDATE\":${result['P_Result'][0][0]['REGDATE']},\"REGRATE\":${result['P_Result'][0][0]['REGRATE']},\"LAST_SALARY\":${result['P_Result'][0][0]['LAST_SALARY']},\"LAST_STODATE\":\"${result['P_Result'][0][0]['LAST_STODATE']}\",\"ACTUAL_STODATE\":${result['P_Result'][0][0]['ACTUAL_STODATE']},\"GENDER\":\"${result['p_per_info'][0][0]['GENDER']}\","
        "\"CIVIL_WORK_DOC\":${result['P_Result'][0][0]['CIVIL_WORK_DOC']},\"MILITARY_WORK_DOC\":${result['P_Result'][0][0]['MILITARY_WORK_DOC']},\"CIV_MIL_RETIRED_DOC\":${result['P_Result'][0][0]['CIV_MIL_RETIRED_DOC']},\"PEN_START_DATE\":${result['P_Result'][0][0]['PEN_START_DATE']},\"GOVERNORATE\":${result['P_Result'][0][0]['GOVERNORATE']},\"DETAILED_ADDRESS\":${result['P_Result'][0][0]['DETAILED_ADDRESS']},"
        "\"PASS_NO\":${result['P_Result'][0][0]['PASS_NO']},\"RESIDENCY_NO\":${result['P_Result'][0][0]['RESIDENCY_NO']},\"DOB\":\"${result['P_Result'][0][0]['DOB']}\",\"JOB_NO\":${result['P_Result'][0][0]['JOB_NO']},\"JOB_DESC\":${result['P_Result'][0][0]['JOB_DESC']},\"ENAME1\":${result['P_Result'][0][0]['ENAME1']},\"ENAME2\":${result['P_Result'][0][0]['ENAME2']},\"ENAME3\":${result['P_Result'][0][0]['ENAME3']},"
        "\"ENAME4\":${result['P_Result'][0][0]['ENAME4']},\"LAST_EST_NO\":${result['P_Result'][0][0]['LAST_EST_NO']},\"FAM_NO\":${result['P_Result'][0][0]['FAM_NO']},\"nextVaild\":${result['P_Result'][0][0]['nextVaild']},\"wantAddFamily\":${result['P_Result'][0][0]['wantAddFamily']},\"GENDER_DESC\":\"${result['p_per_info'][0][0]['GENDER_DESC']}\",\"PI_EPAY\":${result['P_Result'][0][0]['PI_EPAY']},"
        "\"INSURED\":${result['P_Result'][0][0]['INSURED']},\"ID\":${result['P_Result'][0][0]['ID']},\"DEP_FLAG\":${result['P_Result'][0][0]['DEP_FLAG']}}","SERVICE_NO": 8}};
    /// {"params":{"Data":jsonEncode(result),"SERVICE_NO":8}};
    if (kDebugMode) {
      print(jsonEncode(data));
    }
    var response = await HTTPClientContract.instance.postHTTP(
        '/website/GetDocumentRequired', jsonEncode(data)
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }

  /// **************************************************************MEMBERSHIP - START******************************************************************************
  Future optionalSubGetDetailService() async {
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
    String internalKey = userSecuredStorage.insuranceNumber.toString();
    var response = await HTTPClientContract.instance.getHTTP('/individuals/OptionalSub_GetDetail_new?PI_user_name=$internalKey');
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.toString());
    }
    return null;
  }

  /// if (isFirstOptionalSub == [0] or [2]) -> send membership request will call this service
  Future optionalSubInsertNewService(result, int firstOptionalSub,double monthlyPay, double appliedSalary ,int submissionType, int selectedNumberOfIncrements, int selectedMaxPerForInc, String percentDecreaseVal, String selectedMonth) async {
    var data = {
      "SECNO": result['SECNO'],
      "NAME1": result['NAME1'],
      "NAME3": result['NAME3'],
      "MNAME1": result['MNAME1'],
      "LAST_SALARY": result['LAST_SALARY'],
      "MOBILE": result['MOBILE'],
      "BRANCH": result['BRANCH'],
      "NAT_NO": result['NAT_NO'],
      "NAME2": result['NAME2'],
      "NAME4": result['NAME4'],
      "DOB": result['DOB'],
      "EMAIL": result['EMAIL'],
      "LIVELOCATION": result['LIVELOCATION'],
      "PHONECODE": '',
      "INTERNATIONAL_CODE": result['INTERNATIONAL_CODE'],
      "ADDRESS": result['ADDRESS'],
      "REFERANCE_MOBILE": result['REFERANCE_MOBILE'],
      "SALARYREQUST": firstOptionalSub == 2 ? appliedSalary : null,
      "MONTHLYPAY": monthlyPay,
      "SEX": result['SEX'],
      "REG_PER": result['REG_PER'],
      "MAXIMUMSALARYFORCHOOSE": result['MAXIMUMSALARYFORCHOOSE'],
      "MINIMUMSALARYFORCHOOSE": result['MINIMUMSALARYFORCHOOSE'],
      "SUBMITTION_TYPE": submissionType,
      "NOOFINCREMENTS": result['NOOFINCREMENTS'],
      "MAX_PER_OF_INC": result['MAX_PER_OF_INC'],
      "SELECTED_NOOFINCREMENTS": selectedNumberOfIncrements,
      "SELECTED_MAX_PER_OF_INC": selectedMaxPerForInc,
      "APPLIED_SALARY": firstOptionalSub == 2 ? 0 : appliedSalary,
      "PERCENT_DECREASEVAL": percentDecreaseVal != 'null' ? double.parse(percentDecreaseVal) : null,
      "HASBENEFITOFDEC": result['HASBENEFITOFDEC'],
      "HASBENEFITOFINC": result['HASBENEFITOFINC'],
      "MINIMUMSALARYFORDEC": result['MINIMUMSALARYFORDEC'],
      "MAXIMUMSALARYFORDEC": result['MAXIMUMSALARYFORDEC'],
      "EXECLUDED_FROM_PENSION_MONTHS": selectedMonth,
      "SALARY": selectedMonth != null ? appliedSalary : null
    };
    if (kDebugMode) {
      print(jsonEncode(data));
    }
    var response = await HTTPClientContract.instance.postHTTP(
        '/individuals/OPTIONAL_SUB_INSERT_NEW', data
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }

  /// if (isFirstOptionalSub == [1]) -> send membership request will call this service
  Future optionalSubFirstInsertNewService(result, double monthlyPay, double salaryRequest ,int submissionType) async {
    var data = {
      "SECNO": result['SECNO'],
      "NAME1": result['NAME1'],
      "NAME3": result['NAME3'],
      "MNAME1": result['MNAME1'],
      "LAST_SALARY": result['LAST_SALARY'],
      "MOBILE": result['MOBILE'],
      "BRANCH": result['BRANCH'],
      "NAT_NO": result['NAT_NO'],
      "NAME2": result['NAME2'],
      "NAME4": result['NAME4'],
      "DOB": result['DOB'],
      "EMAIL": result['EMAIL'],
      "LIVELOCATION": result['LIVELOCATION'],
      "PHONECODE": null,
      "INTERNATIONAL_CODE": result['INTERNATIONAL_CODE'],
      "ADDRESS": result['ADDRESS'] ?? "jordan",
      "REFERANCE_MOBILE": result['REFERANCE_MOBILE'],
      "SALARYREQUST": salaryRequest,
      "MONTHLYPAY": monthlyPay,
      "SEX": result['SEX'],
      "REG_PER": result['REG_PER'],
      "MAXIMUMSALARYFORCHOOSE": result['MAXIMUMSALARYFORCHOOSE'],
      "MINIMUMSALARYFORCHOOSE": result['MINIMUMSALARYFORCHOOSE'],
      "SUBMITTION_TYPE": submissionType,
      "NOOFINCREMENTS": result['NOOFINCREMENTS'],
      "MAX_PER_OF_INC": result['MAX_PER_OF_INC'],
      "SELECTED_NOOFINCREMENTS": null,
      "SELECTED_MAX_PER_OF_INC": null,
      "APPLIED_SALARY": 0,
      "PERCENT_DECREASEVAL": null,
      "HASBENEFITOFDEC": result['HASBENEFITOFDEC'],
      "HASBENEFITOFINC": result['HASBENEFITOFINC'],
      "MINIMUMSALARYFORDEC": result['MINIMUMSALARYFORDEC'],
      "MAXIMUMSALARYFORDEC": result['MAXIMUMSALARYFORDEC'],
      "EXECLUDED_FROM_PENSION_MONTHS": null,
      "SALARY": null
    };

    if (kDebugMode) {
      print('data: ${jsonEncode(data)}');
    }
    var response = await HTTPClientContract.instance.postHTTP(
        '/individuals/OptionalSubFirst_insert_new', data
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }

  Future optionalSubIncGetDetailNewService() async {
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
    String internalKey = userSecuredStorage.insuranceNumber.toString();
    var response = await HTTPClientContract.instance.getHTTP('/individuals/OptionalSub_Inc_GetDetail_new?secno=$internalKey');
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.toString());
    }
    return null;
  }

  Future submitOptionSubIncrementService(int selectedRate, double newSalary) async {
    var response = await HTTPClientContract.instance.postHTTP(
        '/individuals/SubmitOptionSubIncrement', {"SELECTED_MAX_PER_OF_INC":selectedRate,"BRANCH":60,"SALARYAFTER":newSalary}
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }
/// **************************************************************MEMBERSHIP - END******************************************************************************

/// **************************************************************UPDATE USER MOBILE NUMBER - START*************************************************************
  Future updateUserMobileNumberSendOTPService(String newNumber) async {
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
    int internationalCode = int.tryParse(userSecuredStorage.internationalCode.toString());
    String nationalId = userSecuredStorage.nationalId.toString();
    var response = await HTTPClientContract.instance.postHTTP(
        '/individuals/UPD_USER_PROFILE_INDV_SENDOTP', {"params":{"PI_USERNAME":nationalId,"PI_INTERNATIONALCODE":internationalCode,"PI_MOBILENO":newNumber}}
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }

  Future updateUserMobileNumberCheckOTPService(String code) async {
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
    String nationalId = userSecuredStorage.nationalId.toString();
    var response = await HTTPClientContract.instance.postHTTP(
        '/individuals/UPD_USER_PROFILE_INDV_CHECKOTP', {"params":{"PI_OTP":code,"PI_USER_NAME":nationalId}}
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }

/// **************************************************************UPDATE USER MOBILE NUMBER - END***************************************************************

/// **************************************************************RETIREMENT - START****************************************************************************

  Future getPensionsBasicInformationsService() async {
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
    String internalKey = userSecuredStorage.insuranceNumber.toString();
    var response = await HTTPClientContract.instance.getHTTP('/individuals/pensionsBasicInformation?sceNo=$internalKey');
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.toString());
    }
    return null;
  }

  Future<PensionPaymentModel> getPensionPaymentSPService(String year) async {
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
    String internalKey = userSecuredStorage.insuranceNumber.toString();
    var response = await HTTPClientContract.instance.getHTTP('/individuals/pension_paymentSP?pi_secno=$internalKey&Pi_year=$year');
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return pensionPaymentModelFromJson(response.toString());
    }
    return null;
  }

  Future getEarlyRetirementService() async {
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
    String nationalId = userSecuredStorage.nationalId.toString();
    var response = await HTTPClientContract.instance.getHTTP('/website/get_application?p_app_id=$nationalId&p_app_type=8&p_status=1&p_id=null&isDefense=null');
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.toString());
    }
    return null;
  }


/// **************************************************************RETIREMENT - END******************************************************************************

}