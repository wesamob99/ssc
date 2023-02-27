// ignore_for_file: file_names

import 'dart:convert';

import 'package:dio/dio.dart';
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

  Future getInquiryInsuredInformationService() async {
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
    String internalKey = userSecuredStorage.insuranceNumber.toString();
    var response = await HTTPClientContract.instance.getHTTP('/individuals/inquiryInsuredInformation?sceNo=$internalKey');
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.toString());
    }
    return null;
  }

  Future getInsuredInformationReportService(value) async {
    var data = {
      "formObj": jsonEncode(value["cur_getdata"][0][0]),
      "periods": jsonEncode(value["cur_getdata2"][0]),
      "salaries": jsonEncode(value["cur_getdata3"][0]),
    };
    var response = await HTTPClientContract.instance.postHTTP(
        '/individuals/InsuredInformationReport', data
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return response;
    }
    return '';
  }

  Future getActivePaymentService(String serviceType, String nat) async {
    var response = await HTTPClientContract.instance.getHTTP('/website/getActivePayment?p_service_type=$serviceType&NAT=$nat');
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }

  Future getRequiredDocumentsService(result, serviceNo) async {
    var data = {
      "params":{
        "Data": result,
        "SERVICE_NO": serviceNo
      }
    };
    if (kDebugMode) {
      print('data: ${jsonEncode(data)}');
    }
    var response = await HTTPClientContract.instance.postHTTP(
        '/website/GetDocumentRequired', data
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }

  Future saveFileService(file) async {
    var formData = FormData();
    formData.files.add(MapEntry("Excel", await MultipartFile.fromFile(file.path)));

    var response = await HTTPClientContract.instance.postHTTP(
        '/ftp/saveFile?fileName=&folderName=24', formData
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


  Future updateUserEmailSendOTPService(String email, int firstTime) async {
    var response = await HTTPClientContract.instance.postHTTP(
        '/mobile/email-code',
        {
          "email": email, // string // user email
          "reset": firstTime // 0 -> first time, 1-> reset
        }
    );
    if (kDebugMode) {
      print(response);
    }
    if (response != null && response.statusCode == 200) {
      return jsonDecode(response.data);
    }
    return '';
  }

  Future updateUserEmailCheckOTPService(String email, int code, int firstTime) async {
    var response = await HTTPClientContract.instance.postHTTP(
        '/mobile/email-code-verify',
        {
          "email": email,// string // user email
          "code": code, // number // OTP code
          "reset": firstTime// number // 0 -> first time, 1-> reset
        }
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

  Future getDependentInfoService(String id) async { // get dependent details when adding new dependent from the national ID
    var response = await HTTPClientContract.instance.getHTTP('/website/support_GetDetail?pi_relative_nat_pers_no=$id&PI_relatiev_nat=1');
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

  Future addNewDependentService(String natID) async {
    var response = await HTTPClientContract.instance.getHTTP('/website/support_GetDetail?pi_relative_nat_pers_no=$natID&PI_relatiev_nat=1');
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

  Future setEarlyRetirementApplicationService(result, docs, paymentInfo, int authorizedToSign, int wantInsurance) async {
    var row = {
      /// payment info
      "PAYMENT_METHOD": paymentInfo['PAYMENT_METHOD'],
      "BANK_LOCATION": paymentInfo['BANK_LOCATION'],
      "BRANCH_ID": paymentInfo['BRANCH_ID'],
      "BRANCH_NAME": paymentInfo['BRANCH_NAME'],
      "BANK_ID": paymentInfo['BANK_ID'],
      "BANK_NAME": paymentInfo['BANK_NAME'],
      "ACCOUNT_NAME": paymentInfo['ACCOUNT_NAME'],
      "PAYMENT_COUNTRY": paymentInfo['PAYMENT_COUNTRY'],
      "PAYMENT_COUNTRY_CODE": paymentInfo['PAYMENT_COUNTRY_CODE'],
      "PAYMENT_PHONE": paymentInfo['PAYMENT_PHONE'],
      "SWIFT_CODE": paymentInfo['SWIFT_CODE'],
      "BANK_DETAILS": paymentInfo['BANK_DETAILS'],
      "IBAN": paymentInfo['IBAN'] ?? "",
      "CASH_BANK_ID": paymentInfo['CASH_BANK_ID'],
      "REP_NATIONALITY": paymentInfo['REP_NATIONALITY'],
      "REP_NATIONAL_NO": paymentInfo['REP_NATIONAL_NO'],
      "REP_NAME": paymentInfo['REP_NAME'],
      "WALLET_TYPE": paymentInfo['WALLET_TYPE'],
      "WALLET_OTP_VERIVIED": paymentInfo['WALLET_OTP_VERIVIED'],
      "WALLET_OTP": paymentInfo['WALLET_OTP'],
      "WALLET_PHONE": paymentInfo['WALLET_PHONE'],
      "WALLET_PHONE_VERIVIED": paymentInfo['WALLET_PHONE_VERIVIED'],
      "WALLET_PASSPORT_NUMBER": paymentInfo['WALLET_PASSPORT_NUMBER'],
      "PEN_IBAN": paymentInfo['PEN_IBAN'],
      "IBAN_CONFIG": "1",
      /// ***
      "IFSC": result['P_Result'][0][0]['IFSC'] ?? "",
      "APPROVE_DISCLOSURE": 1,
      "NOT_APPROVE_REASON": null,
      "SIG_ATHORIZED": authorizedToSign,
      "WANT_INSURANCE": wantInsurance,
      "OFFNO": result['P_Result'][0][0]['OFFNO'],
      "AGREE_TERMS": 1,
      "SECNO": result['p_per_info'][0][0]['SECNO'],
      "NAT_DESC": result['p_per_info'][0][0]['NAT_DESC'],
      "NAT": result['P_Result'][0][0]['NAT'],
      "NAT_NO": result['P_Result'][0][0]['NAT_NO'],
      "PERS_NO": result['P_Result'][0][0]['PERS_NO'],
      "LAST_EST_NAME": result['p_per_info'][0][0]['LAST_EST_NAME'],
      "NAME1": result['p_per_info'][0][0]['NAME1'],
      "NAME2": result['p_per_info'][0][0]['NAME2'],
      "NAME3": result['p_per_info'][0][0]['NAME3'],
      "NAME4": result['p_per_info'][0][0]['NAME4'],
      "FULL_NAME_EN": result['p_per_info'][0][0]['FULL_NAME_EN'],
      "EMAIL": result['p_per_info'][0][0]['EMAIL'],
      "MOBILE": result['p_per_info'][0][0]['MOBILE'],
      "INTERNATIONAL_CODE": result['p_per_info'][0][0]['INTERNATIONAL_CODE'],
      "INSURED_ADDRESS": result['P_Result'][0][0]['INSURED_ADDRESS'],
      "MARITAL_STATUS": result['P_Result'][0][0]['MARITAL_STATUS'],
      "REGDATE": null, /// not found
      "REGRATE": null, /// not found
      "LAST_SALARY": null, /// not found
      "LAST_STODATE": result['P_Result'][0][0]['LAST_STODATE'],
      "ACTUAL_STODATE": result['P_Result'][0][0]['ACTUAL_STODATE'],
      "GENDER": result['p_per_info'][0][0]['GENDER'],
      "CIVIL_WORK_DOC": result['P_Result'][0][0]['CIVIL_WORK_DOC'],
      "MILITARY_WORK_DOC": result['P_Result'][0][0]['MILITARY_WORK_DOC'],
      "CIV_MIL_RETIRED_DOC": result['P_Result'][0][0]['CIV_MIL_RETIRED_DOC'],
      "PEN_START_DATE": result['P_Result'][0][0]['PEN_START_DATE'],
      "GOVERNORATE": result['P_Result'][0][0]['GOVERNORATE'],
      "DETAILED_ADDRESS": null, /// not found
      "PASS_NO": null, /// not found
      "RESIDENCY_NO": null, /// not found
      "DOB": result['p_per_info'][0][0]['DOB'],
      "JOB_NO": null, /// not found
      "JOB_DESC": result['P_Result'][0][0]['JOB_DESC'],
      "ENAME1": null, /// not found
      "ENAME2": null, /// not found
      "ENAME3": null, /// not found
      "ENAME4": null, /// not found
      "LAST_EST_NO": result['p_per_info'][0][0]['LAST_EST_NO'],
      "FAM_NO": null, /// not found
      "nextVaild": null, /// not found
      "wantAddFamily": null, /// not found
      "GENDER_DESC": result['p_per_info'][0][0]['GENDER_DESC'],
      "PI_EPAY": null, /// not found
      "INSURED": null, /// not found
      "APPLICANT_ID": int.parse(result['P_Result'][0][0]['APPLICANT_ID'].toString()),
      "APPLICANT_NO": result['P_Result'][0][0]['APPLICANT_NO'],
      "SERVICE_TYPE": result['P_Result'][0][0]['SERVICE_TYPE'],
      "IS_DEFENSE": result['P_Result'][0][0]['IS_DEFENSE'],
      "APP_STATUS_EXTERNAL": 2,
      "OTHER_DEPENDANTS": result['P_Result'][0][0]['OTHER_DEPENDANTS'],
      "ID": result['P_Result'][0][0]['ID'],
      "LEAVE_START_DATE": result['P_Result'][0][0]['LEAVE_START_DATE'],
      "LEAVE_END_DATE": result['P_Result'][0][0]['LEAVE_END_DATE'],
      "BIRTH_DATE": result['P_Result'][0][0]['BIRTH_DATE'],
    };
    var data = {
      "params": {
        "XML": jsonEncode(
          {
            "row": row,
            "doc": docs,
            "dep": result["P_Dep"].isNotEmpty ? result["P_Dep"][0] : [],
            "INHERITORS": [], // value always [] in early retirement
            "isWebsite": false
          }
        )
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

  // {"params":{"Obj":"{\"row\":{\"NAT\":\"111\",\"GENDER\":\"1\"},\"dep\":[]}"}}
  Future checkDocumentDependentService(String gender,
      {String natID,
      String fName,
      String sName,
      String thName,
      String lName,
      String dateOfBirth,
      int nationality,
      List dependents}) async {
    dependents.add({
          "ID": "",
          "FIRSTNAME": fName,
          "SECONDNAME": sName,
          "THIRDNAME": thName,
          "LASTNAME": lName,
          "BIRTHDATE": dateOfBirth,
          "NATIONALITY": nationality,
          "NATIONAL_NO": natID,
          "RELATION": 2,
          "GENDER": 1,
          "AGE": "",
          "MARITAL_STATUS": "",
          "MARITAL_STATUS_A": 2,
          "WORK_STATUS": "",
          "WORK_STATUS_A": 1,
          "IS_ALIVE": "",
          "IS_ALIVE_A": "",
          "LAST_EVENT_DATE": null,
          "DISABILITY": 0,
          "WANT_HEALTH_INSURANCE": "",
          "PreLoad": 0,
          "Added": 1,
          "SOURCE_FLAG": 2,
          "doc_dep": [],
          "REQ_DOC": "",
          "IS_RETIRED": "",
          "IS_RETIRED_A": 1,
          "DEP_CODE": "167559085073882",
          "IS_STOP": ""
        });
    var response = await HTTPClientContract.instance.postHTTP(
        '/website/check_doc_dep', {"params": {
            "Obj": jsonEncode({
              "row": {
                "NAT": "111",
                "GENDER": gender
              },
              "dep": nationality != 1
              ? dependents
              : []
            })
          }
        }
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