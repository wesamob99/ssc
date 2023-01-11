// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:ssc/infrastructure/userSecuredStorage.dart';

import '../../../infrastructure/HTTPClientContract.dart';
import '../../../models/services/getEarlyRetirementModel.dart';
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

  Future deleteDependentService(int id) async {
    var response = await HTTPClientContract.instance.postHTTP(
        '/website/DELETE_DEP', {"PI_ID": id}
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }

  Future setEarlyRetirementApplicationService(result) async {

    GetEarlyRetirementModel earlyRetirementModel = result;
    earlyRetirementModel.pResult[0][0].bankLocation = earlyRetirementModel.pResult[0][0].bankLocation ?? 1;
    earlyRetirementModel.pResult[0][0].swiftCode = earlyRetirementModel.pResult[0][0].swiftCode ?? '';
    earlyRetirementModel.pResult[0][0].bankDetails = earlyRetirementModel.pResult[0][0].bankDetails ?? '';
    earlyRetirementModel.pResult[0][0].iban = null;
    earlyRetirementModel.pResult[0][0].repNationality = earlyRetirementModel.pResult[0][0].repNationality ?? '';
    earlyRetirementModel.pResult[0][0].repNationalNo = earlyRetirementModel.pResult[0][0].repNationalNo ?? '';
    earlyRetirementModel.pResult[0][0].repName = earlyRetirementModel.pResult[0][0].repName ?? '';
    earlyRetirementModel.pResult[0][0].notApproveReason = earlyRetirementModel.pResult[0][0].notApproveReason ?? '';

    var data = {
      "params": {
        "XML": {
           "row": {
             "PAYMENT_METHOD": 3,
             "BANK_LOCATION": 1,
             "BRANCH_ID": 1001,
             "BRANCH_NAME": null,
             "BANK_ID": 1000,
             "BANK_NAME": null,
             "ACCOUNT_NAME": null,
             "PAYMENT_COUNTRY": null,
             "PAYMENT_COUNTRY_CODE": null,
             "PAYMENT_PHONE": null,
             "IFSC": null,
             "SWIFT_CODE": "",
             "BANK_DETAILS": "",
             "IBAN": null,
             "CASH_BANK_ID": null,
             "REP_NATIONALITY": "",
             "REP_NATIONAL_NO": "",
             "REP_NAME": "",
             "WALLET_TYPE": null,
             "WALLET_OTP_VERIVIED": null,
             "WALLET_OTP": null,
             "WALLET_PHONE": null,
             "WALLET_PHONE_VERIVIED": null,
             "WALLET_PASSPORT_NUMBER": null,
             "PEN_IBAN": null,
             "APPROVE_DISCLOSURE": 1,
             "NOT_APPROVE_REASON": "",
             "SIG_ATHORIZED": 1,
             "WANT_INSURANCE": "0",
             "OFFNO": 60,
             "AGREE_TERMS": 1,
             "SECNO": 9691014000,
             "NAT_DESC": "الاردن",
             "NAT": 111,
             "NAT_NO": 9691035582,
             "PERS_NO": null,
             "LAST_EST_NAME": "شركة **********",
             "NAME1": "فراس",
             "NAME2": "فائق سميح",
             "NAME3": "محمد",
             "NAME4": "حبول",
             "FULL_NAME_EN": "F F M H",
             "EMAIL": "fhabool@ssc.gov.jo",
             "MOBILE": 795567682,
             "INTERNATIONAL_CODE": 962,
             "INSURED_ADDRESS": null,
             "MARITAL_STATUS": null,
             "REGDATE": null,
             "REGRATE": null,
             "LAST_SALARY": null,
             "LAST_STODATE": "25/10/4670",
             "ACTUAL_STODATE": null,
             "GENDER": "1",
             "CIVIL_WORK_DOC": 1,
             "MILITARY_WORK_DOC": 0,
             "CIV_MIL_RETIRED_DOC": 0,
             "PEN_START_DATE": null,
             "GOVERNORATE": null,
             "DETAILED_ADDRESS": null,
             "PASS_NO": null,
             "RESIDENCY_NO": null,
             "DOB": "16/08/1969",
             "JOB_NO": null,
             "JOB_DESC": null,
             "ENAME1": null,
             "ENAME2": null,
             "ENAME3": null,
             "ENAME4": null,
             "LAST_EST_NO": 66500,
             "FAM_NO": null,
             "nextVaild": null,
             "wantAddFamily": null,
             "GENDER_DESC": "ذكر",
             "PI_EPAY": null,
             "INSURED": null,
             "APPLICANT_ID": "9691035582",
             "APPLICANT_NO": "9691035582",
             "SERVICE_TYPE": 8,
             "IS_DEFENSE": null,
             "APP_STATUS_EXTERNAL": 2,
             "OTHER_DEPENDANTS": 0,
             "ID": 4252,
             "LEAVE_START_DATE": null,
             "LEAVE_END_DATE": null,
             "BIRTH_DATE": null,
             "IBAN_CONFIG": "1"
           },
           "doc": [
             {
               "PATH": "./i5d61brglcrd04o6.png",
               "DOC_TYPE": 8,
               "FILE": {},
               "FILE_NAME": "thumbnail_image013 (1).png",
               "DOC_TYPE_DESC_AR": "",
               "DOC_TYPE_DESC_EN": "",
               "DOCUMENT_DATE": "11/01/2023, 10:45",
               "required": 0,
               "APP_ID": 4252,
               "ID": "",
               "STATUS": 1,
               "HIDE_ACTIONS": false
             }
           ],
           "dep": [
             {
               "ID": 7950,
               "FIRSTNAME": "ليدا",
               "SECONDNAME": "فراس",
               "THIRDNAME": "فائق سميح",
               "LASTNAME": "حبول",
               "BIRTHDATE": "11/09/2005",
               "NATIONALITY": "1",
               "NATIONAL_NO": "2001108378",
               "RELATION": 6,
               "GENDER": 2,
               "AGE": 17,
               "MARITAL_STATUS": 1,
               "MARITAL_STATUS_A": 1,
               "WORK_STATUS": "0",
               "WORK_STATUS_A": 0,
               "IS_ALIVE": 1,
               "IS_ALIVE_A": 1,
               "LAST_EVENT_DATE": null,
               "DISABILITY": 0,
               "WANT_HEALTH_INSURANCE": "",
               "PreLoad": 1,
               "Added": 0,
               "SOURCE_FLAG": 1,
               "doc_dep": [],
               "REQ_DOC": "",
               "MERIT": null,
               "IS_RETIRED": 0,
               "IS_RETIRED_A": 0,
               "DEP_CODE": "4931906202212241999149300000"
             },
             {
               "ID": 7951,
               "FIRSTNAME": "هبه",
               "SECONDNAME": "محمد منذر",
               "THIRDNAME": "محمد",
               "LASTNAME": "تفاحه",
               "BIRTHDATE": "21/06/1973",
               "NATIONALITY": "1",
               "NATIONAL_NO": "9732031054",
               "RELATION": 11,
               "GENDER": 2,
               "AGE": 49,
               "MARITAL_STATUS": 2,
               "MARITAL_STATUS_A": 2,
               "WORK_STATUS": "0",
               "WORK_STATUS_A": 0,
               "IS_ALIVE": 1,
               "IS_ALIVE_A": 1,
               "LAST_EVENT_DATE": "08/11/2004",
               "DISABILITY": 0,
               "WANT_HEALTH_INSURANCE": "",
               "PreLoad": 1,
               "Added": 0,
               "SOURCE_FLAG": 1,
               "doc_dep": [],
               "REQ_DOC": "",
               "MERIT": null,
               "IS_RETIRED": 1,
               "IS_RETIRED_A": 1,
               "DEP_CODE": "4421906202212242049344200001"
             },
             {
               "ID": 7952,
               "FIRSTNAME": "عمر",
               "SECONDNAME": "فراس",
               "THIRDNAME": "فائق سميح",
               "LASTNAME": "حبول",
               "BIRTHDATE": "04/08/2013",
               "NATIONALITY": "1",
               "NATIONAL_NO": "2002845830",
               "RELATION": 5,
               "GENDER": 1,
               "AGE": 9,
               "MARITAL_STATUS": 1,
               "MARITAL_STATUS_A": 1,
               "WORK_STATUS": "0",
               "WORK_STATUS_A": 0,
               "IS_ALIVE": 1,
               "IS_ALIVE_A": 1,
               "LAST_EVENT_DATE": null,
               "DISABILITY": 0,
               "WANT_HEALTH_INSURANCE": "",
               "PreLoad": 1,
               "Added": 0,
               "SOURCE_FLAG": 1,
               "doc_dep": [],
               "REQ_DOC": "",
               "MERIT": null,
               "IS_RETIRED": 0,
               "IS_RETIRED_A": 0,
               "DEP_CODE": "1671906202212242099516700002"
             },
             {
               "ID": 7953,
               "FIRSTNAME": "جنى",
               "SECONDNAME": "فراس",
               "THIRDNAME": "فائق سميح",
               "LASTNAME": "حبول",
               "BIRTHDATE": "27/07/2008",
               "NATIONALITY": "1",
               "NATIONAL_NO": "2001707246",
               "RELATION": 6,
               "GENDER": 2,
               "AGE": 14,
               "MARITAL_STATUS": 1,
               "MARITAL_STATUS_A": 1,
               "WORK_STATUS": "0",
               "WORK_STATUS_A": 0,
               "IS_ALIVE": 1,
               "IS_ALIVE_A": 1,
               "LAST_EVENT_DATE": "22/06/2022",
               "DISABILITY": 0,
               "WANT_HEALTH_INSURANCE": "",
               "PreLoad": 1,
               "Added": 0,
               "SOURCE_FLAG": 1,
               "doc_dep": [],
               "REQ_DOC": "",
               "MERIT": null,
               "IS_RETIRED": 0,
               "IS_RETIRED_A": 0,
               "DEP_CODE": "99190620221224214979900003"
             }
           ],
           "INHERITORS": [],
           "isWebsite": true
          }
      }
    };

    var response = await HTTPClientContract.instance.postHTTP(
        '/website/set_application', data
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }

/// **************************************************************RETIREMENT - END******************************************************************************

}