// To parse this JSON data, do
//
//     final getEarlyRetirementModel = getEarlyRetirementModelFromJson(jsonString);

import 'dart:convert';

GetEarlyRetirementModel getEarlyRetirementModelFromJson(String str) => GetEarlyRetirementModel.fromJson(json.decode(str));

String getEarlyRetirementModelToJson(GetEarlyRetirementModel data) => json.encode(data.toJson());

class GetEarlyRetirementModel {
  GetEarlyRetirementModel({
    this.pPerInfo,
    this.pResult,
    this.pDoc,
    this.pDep,
    this.pMessage,
    this.pDepInfo,
    this.pRelation,
    this.pMarital,
    this.pLaonType,
    this.pDeadLoan,
  });

  List<List<PPerInfo>> pPerInfo;
  List<List<PResult>> pResult;
  List<dynamic> pDoc;
  List<List<PDep>> pDep;
  List<List<PMessage>> pMessage;
  List<List<PDepInfo>> pDepInfo;
  List<List<PRelation>> pRelation;
  List<List<PMarital>> pMarital;
  List<dynamic> pLaonType;
  List<dynamic> pDeadLoan;

  factory GetEarlyRetirementModel.fromJson(Map<String, dynamic> json) => GetEarlyRetirementModel(
    pPerInfo: json["p_per_info"] == null ? [] : List<List<PPerInfo>>.from(json["p_per_info"].map((x) => List<PPerInfo>.from(x.map((x) => PPerInfo.fromJson(x))))),
    pResult: json["P_Result"] == null ? [] : List<List<PResult>>.from(json["P_Result"].map((x) => List<PResult>.from(x.map((x) => PResult.fromJson(x))))),
    pDoc: json["P_Doc"] == null ? [] : List<dynamic>.from(json["P_Doc"].map((x) => x)),
    pDep: json["P_Dep"] == null ? [] : List<List<PDep>>.from(json["P_Dep"].map((x) => List<PDep>.from(x.map((x) => PDep.fromJson(x))))),
    pMessage: json["P_Message"] == null ? [] : List<List<PMessage>>.from(json["P_Message"].map((x) => List<PMessage>.from(x.map((x) => PMessage.fromJson(x))))),
    pDepInfo: json["P_DEP_INFO"] == null ? [] : List<List<PDepInfo>>.from(json["P_DEP_INFO"].map((x) => List<PDepInfo>.from(x.map((x) => PDepInfo.fromJson(x))))),
    pRelation: json["P_RELATION"] == null ? [] : List<List<PRelation>>.from(json["P_RELATION"].map((x) => List<PRelation>.from(x.map((x) => PRelation.fromJson(x))))),
    pMarital: json["P_MARITAL"] == null ? [] : List<List<PMarital>>.from(json["P_MARITAL"].map((x) => List<PMarital>.from(x.map((x) => PMarital.fromJson(x))))),
    pLaonType: json["P_LAON_TYPE"] == null ? [] : List<dynamic>.from(json["P_LAON_TYPE"].map((x) => x)),
    pDeadLoan: json["P_DEAD_LOAN"] == null ? [] : List<dynamic>.from(json["P_DEAD_LOAN"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "p_per_info": pPerInfo == null ? [] : List<dynamic>.from(pPerInfo.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
    "P_Result": pResult == null ? [] : List<dynamic>.from(pResult.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
    "P_Doc": pDoc == null ? [] : List<dynamic>.from(pDoc.map((x) => x)),
    "P_Dep": pDep == null ? [] : List<dynamic>.from(pDep.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
    "P_Message": pMessage == null ? [] : List<dynamic>.from(pMessage.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
    "P_DEP_INFO": pDepInfo == null ? [] : List<dynamic>.from(pDepInfo.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
    "P_RELATION": pRelation == null ? [] : List<dynamic>.from(pRelation.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
    "P_MARITAL": pMarital == null ? [] : List<dynamic>.from(pMarital.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
    "P_LAON_TYPE": pLaonType == null ? [] : List<dynamic>.from(pLaonType.map((x) => x)),
    "P_DEAD_LOAN": pDeadLoan == null ? [] : List<dynamic>.from(pDeadLoan.map((x) => x)),
  };
}

class PDep {
  PDep({
    this.id,
    this.nationality,
    this.nationalNo,
    this.age,
    this.disability,
    this.rvMeaningAr,
    this.rvMeaningEn,
    this.gender,
    this.relation,
    this.maritalStatus,
    this.dependancyStatus,
    this.applicationId,
    this.amendType,
    this.amendReason,
    this.workStatus,
    this.workStatusA,
    this.maritalStatusA,
    this.isAlive,
    this.isAliveA,
    this.lastEventDate,
    this.accepted,
    this.sourceFlag,
    this.birthdate,
    this.name,
    this.firstname,
    this.secondname,
    this.thirdname,
    this.lastname,
    this.merit,
    this.reqDoc,
    this.isRetired,
    this.isRetiredA,
    this.depCode,
  });

  int id;
  int nationality;
  String nationalNo;
  int age;
  int disability;
  dynamic rvMeaningAr;
  dynamic rvMeaningEn;
  int gender;
  int relation;
  int maritalStatus;
  dynamic dependancyStatus;
  int applicationId;
  dynamic amendType;
  dynamic amendReason;
  int workStatus;
  int workStatusA;
  int maritalStatusA;
  int isAlive;
  int isAliveA;
  String lastEventDate;
  dynamic accepted;
  int sourceFlag;
  String birthdate;
  String name;
  String firstname;
  String secondname;
  String thirdname;
  String lastname;
  dynamic merit;
  dynamic reqDoc;
  int isRetired;
  int isRetiredA;
  String depCode;

  factory PDep.fromJson(Map<String, dynamic> json) => PDep(
    id: json["ID"],
    nationality: json["NATIONALITY"],
    nationalNo: json["NATIONAL_NO"],
    age: json["AGE"],
    disability: json["DISABILITY"],
    rvMeaningAr: json["RV_MEANING_AR"],
    rvMeaningEn: json["RV_MEANING_EN"],
    gender: json["GENDER"],
    relation: json["RELATION"],
    maritalStatus: json["MARITAL_STATUS"],
    dependancyStatus: json["DEPENDANCY_STATUS"],
    applicationId: json["APPLICATION_ID"],
    amendType: json["AMEND_TYPE"],
    amendReason: json["AMEND_REASON"],
    workStatus: json["WORK_STATUS"],
    workStatusA: json["WORK_STATUS_A"],
    maritalStatusA: json["MARITAL_STATUS_A"],
    isAlive: json["IS_ALIVE"],
    isAliveA: json["IS_ALIVE_A"],
    lastEventDate: json["LAST_EVENT_DATE"],
    accepted: json["ACCEPTED"],
    sourceFlag: json["SOURCE_FLAG"],
    birthdate: json["BIRTHDATE"],
    name: json["NAME"],
    firstname: json["FIRSTNAME"],
    secondname: json["SECONDNAME"],
    thirdname: json["THIRDNAME"],
    lastname: json["LASTNAME"],
    merit: json["MERIT"],
    reqDoc: json["REQ_DOC"],
    isRetired: json["IS_RETIRED"],
    isRetiredA: json["IS_RETIRED_A"],
    depCode: json["DEP_CODE"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "NATIONALITY": nationality,
    "NATIONAL_NO": nationalNo,
    "AGE": age,
    "DISABILITY": disability,
    "RV_MEANING_AR": rvMeaningAr,
    "RV_MEANING_EN": rvMeaningEn,
    "GENDER": gender,
    "RELATION": relation,
    "MARITAL_STATUS": maritalStatus,
    "DEPENDANCY_STATUS": dependancyStatus,
    "APPLICATION_ID": applicationId,
    "AMEND_TYPE": amendType,
    "AMEND_REASON": amendReason,
    "WORK_STATUS": workStatus,
    "WORK_STATUS_A": workStatusA,
    "MARITAL_STATUS_A": maritalStatusA,
    "IS_ALIVE": isAlive,
    "IS_ALIVE_A": isAliveA,
    "LAST_EVENT_DATE": lastEventDate,
    "ACCEPTED": accepted,
    "SOURCE_FLAG": sourceFlag,
    "BIRTHDATE": birthdate,
    "NAME": name,
    "FIRSTNAME": firstname,
    "SECONDNAME": secondname,
    "THIRDNAME": thirdname,
    "LASTNAME": lastname,
    "MERIT": merit,
    "REQ_DOC": reqDoc,
    "IS_RETIRED": isRetired,
    "IS_RETIRED_A": isRetiredA,
    "DEP_CODE": depCode,
  };
}

class PDepInfo {
  PDepInfo({
    this.nationalnumber,
    this.fullName,
    this.firstname,
    this.secondname,
    this.thirdname,
    this.lastname,
    this.gender,
    this.nationality,
    this.relativetype,
    this.isWork,
    this.socialStatus,
    this.lastSocStatusDate,
    this.isAlive,
    this.deadDate,
    this.age,
    this.birthdate,
    this.isRetired,
    this.isSupportToOtherPen,
  });

  String nationalnumber;
  String fullName;
  String firstname;
  String secondname;
  String thirdname;
  String lastname;
  int gender;
  int nationality;
  int relativetype;
  int isWork;
  int socialStatus;
  String lastSocStatusDate;
  int isAlive;
  dynamic deadDate;
  String age;
  String birthdate;
  int isRetired;
  int isSupportToOtherPen;

  factory PDepInfo.fromJson(Map<String, dynamic> json) => PDepInfo(
    nationalnumber: json["NATIONALNUMBER"],
    fullName: json["FULL_NAME"],
    firstname: json["FIRSTNAME"],
    secondname: json["SECONDNAME"],
    thirdname: json["THIRDNAME"],
    lastname: json["LASTNAME"],
    gender: json["GENDER"],
    nationality: json["NATIONALITY"],
    relativetype: json["RELATIVETYPE"],
    isWork: json["IS_WORK"],
    socialStatus: json["SOCIAL_STATUS"],
    lastSocStatusDate: json["LAST_SOC_STATUS_DATE"],
    isAlive: json["IS_ALIVE"],
    deadDate: json["DEAD_DATE"],
    age: json["AGE"],
    birthdate: json["BIRTHDATE"],
    isRetired: json["IS_RETIRED"],
    isSupportToOtherPen: json["IS_SUPPORT_TO_OTHER_PEN"],
  );

  Map<String, dynamic> toJson() => {
    "NATIONALNUMBER": nationalnumber,
    "FULL_NAME": fullName,
    "FIRSTNAME": firstname,
    "SECONDNAME": secondname,
    "THIRDNAME": thirdname,
    "LASTNAME": lastname,
    "GENDER": gender,
    "NATIONALITY": nationality,
    "RELATIVETYPE": relativetype,
    "IS_WORK": isWork,
    "SOCIAL_STATUS": socialStatus,
    "LAST_SOC_STATUS_DATE": lastSocStatusDate,
    "IS_ALIVE": isAlive,
    "DEAD_DATE": deadDate,
    "AGE": age,
    "BIRTHDATE": birthdate,
    "IS_RETIRED": isRetired,
    "IS_SUPPORT_TO_OTHER_PEN": isSupportToOtherPen,
  };
}

class PMarital {
  PMarital({
    this.socStatusId,
    this.socStatusDescAr,
    this.socStatusDescEn,
  });

  int socStatusId;
  String socStatusDescAr;
  String socStatusDescEn;

  factory PMarital.fromJson(Map<String, dynamic> json) => PMarital(
    socStatusId: json["SOC_STATUS_ID"],
    socStatusDescAr: json["SOC_STATUS_DESC_AR"],
    socStatusDescEn: json["SOC_STATUS_DESC_EN"],
  );

  Map<String, dynamic> toJson() => {
    "SOC_STATUS_ID": socStatusId,
    "SOC_STATUS_DESC_AR": socStatusDescAr,
    "SOC_STATUS_DESC_EN": socStatusDescEn,
  };
}

class PMessage {
  PMessage({
    this.poStatus,
    this.poType,
    this.poStatusDescAr,
    this.poStatusDescEn,
  });

  int poStatus;
  int poType;
  dynamic poStatusDescAr;
  dynamic poStatusDescEn;

  factory PMessage.fromJson(Map<String, dynamic> json) => PMessage(
    poStatus: json["PO_STATUS"],
    poType: json["PO_TYPE"],
    poStatusDescAr: json["PO_STATUS_DESC_AR"],
    poStatusDescEn: json["PO_STATUS_DESC_EN"],
  );

  Map<String, dynamic> toJson() => {
    "PO_STATUS": poStatus,
    "PO_TYPE": poType,
    "PO_STATUS_DESC_AR": poStatusDescAr,
    "PO_STATUS_DESC_EN": poStatusDescEn,
  };
}

class PPerInfo {
  PPerInfo({
    this.secno,
    this.name1,
    this.name2,
    this.name3,
    this.name4,
    this.fullNameAr,
    this.fullNameEn,
    this.dob,
    this.mname1,
    this.natNo,
    this.persNo,
    this.gender,
    this.genderDesc,
    this.genderDescEn,
    this.nat,
    this.natDesc,
    this.natDescEn,
    this.mobile,
    this.internationalCode,
    this.email,
    this.bankNo,
    this.bankBranchCode,
    this.iban,
    this.livelocation,
    this.lastEstNo,
    this.lastEstName,
    this.lastStodate,
    this.actualStodate,
    this.offno,
    this.militaryWorkDoc,
    this.civilWorkDoc,
    this.civMilRetiredDoc,
  });

  int secno;
  String name1;
  String name2;
  String name3;
  String name4;
  String fullNameAr;
  String fullNameEn;
  String dob;
  String mname1;
  int natNo;
  dynamic persNo;
  String gender;
  String genderDesc;
  String genderDescEn;
  String nat;
  String natDesc;
  String natDescEn;
  int mobile;
  int internationalCode;
  String email;
  int bankNo;
  String bankBranchCode;
  String iban;
  int livelocation;
  int lastEstNo;
  String lastEstName;
  String lastStodate;
  dynamic actualStodate;
  int offno;
  int militaryWorkDoc;
  int civilWorkDoc;
  int civMilRetiredDoc;

  factory PPerInfo.fromJson(Map<String, dynamic> json) => PPerInfo(
    secno: json["SECNO"],
    name1: json["NAME1"],
    name2: json["NAME2"],
    name3: json["NAME3"],
    name4: json["NAME4"],
    fullNameAr: json["FULL_NAME_AR"],
    fullNameEn: json["FULL_NAME_EN"],
    dob: json["DOB"],
    mname1: json["MNAME1"],
    natNo: json["NAT_NO"],
    persNo: json["PERS_NO"],
    gender: json["GENDER"],
    genderDesc: json["GENDER_DESC"],
    genderDescEn: json["GENDER_DESC_EN"],
    nat: json["NAT"],
    natDesc: json["NAT_DESC"],
    natDescEn: json["NAT_DESC_EN"],
    mobile: json["MOBILE"],
    internationalCode: json["INTERNATIONAL_CODE"],
    email: json["EMAIL"],
    bankNo: json["BANK_NO"],
    bankBranchCode: json["BANK_BRANCH_CODE"],
    iban: json["IBAN"],
    livelocation: json["LIVELOCATION"],
    lastEstNo: json["LAST_EST_NO"],
    lastEstName: json["LAST_EST_NAME"],
    lastStodate: json["LAST_STODATE"],
    actualStodate: json["ACTUAL_STODATE"],
    offno: json["OFFNO"],
    militaryWorkDoc: json["MILITARY_WORK_DOC"],
    civilWorkDoc: json["CIVIL_WORK_DOC"],
    civMilRetiredDoc: json["CIV_MIL_RETIRED_DOC"],
  );

  Map<String, dynamic> toJson() => {
    "SECNO": secno,
    "NAME1": name1,
    "NAME2": name2,
    "NAME3": name3,
    "NAME4": name4,
    "FULL_NAME_AR": fullNameAr,
    "FULL_NAME_EN": fullNameEn,
    "DOB": dob,
    "MNAME1": mname1,
    "NAT_NO": natNo,
    "PERS_NO": persNo,
    "GENDER": gender,
    "GENDER_DESC": genderDesc,
    "GENDER_DESC_EN": genderDescEn,
    "NAT": nat,
    "NAT_DESC": natDesc,
    "NAT_DESC_EN": natDescEn,
    "MOBILE": mobile,
    "INTERNATIONAL_CODE": internationalCode,
    "EMAIL": email,
    "BANK_NO": bankNo,
    "BANK_BRANCH_CODE": bankBranchCode,
    "IBAN": iban,
    "LIVELOCATION": livelocation,
    "LAST_EST_NO": lastEstNo,
    "LAST_EST_NAME": lastEstName,
    "LAST_STODATE": lastStodate,
    "ACTUAL_STODATE": actualStodate,
    "OFFNO": offno,
    "MILITARY_WORK_DOC": militaryWorkDoc,
    "CIVIL_WORK_DOC": civilWorkDoc,
    "CIV_MIL_RETIRED_DOC": civMilRetiredDoc,
  };
}

class PRelation {
  PRelation({
    this.relId,
    this.relDescAr,
    this.relDescEn,
  });

  int relId;
  String relDescAr;
  String relDescEn;

  factory PRelation.fromJson(Map<String, dynamic> json) => PRelation(
    relId: json["REL_ID"],
    relDescAr: json["REL_DESC_AR"],
    relDescEn: json["REL_DESC_EN"],
  );

  Map<String, dynamic> toJson() => {
    "REL_ID": relId,
    "REL_DESC_AR": relDescAr,
    "REL_DESC_EN": relDescEn,
  };
}

class PResult {
  PResult({
    this.id,
    this.applicationDate,
    this.applicationNum,
    this.agreeTerms,
    this.appStatusInternal,
    this.appStatusInternalDescAr,
    this.appStatusInternalDescEn,
    this.approveDisclosure,
    this.notApproveReason,
    this.applicantId,
    this.coorpId,
    this.coorpDesc,
    this.applicantNo,
    this.serviceType,
    this.serviceTypeDescAr,
    this.serviceTypeDescEn,
    this.bankLocation,
    this.bankId,
    this.bankDescAr,
    this.bankDescEn,
    this.branchId,
    this.iban,
    this.bankDetails,
    this.swiftCode,
    this.repNationality,
    this.repNationalNo,
    this.repName,
    this.receiptMethod,
    this.phoneNumber,
    this.insuredAddress,
    this.maritalStatus,
    this.serviceSubType,
    this.paymentMethod,
    this.paymentMethodDescAr,
    this.paymentMethodDescEn,
    this.otherDependants,
    this.sigAthorized,
    this.businessOwner,
    this.birthPlace,
    this.childNationality,
    this.childNatNo,
    this.birthDate,
    this.birthExpectation,
    this.leaveStartDate,
    this.leaveEndDate,
    this.inactiveReason,
    this.returnDate,
    this.compensationReason,
    this.compensationReasonDescAr,
    this.compensationReasonDescEn,
    this.occupationSubSid,
    this.jobDesc,
    this.symptoms,
    this.symptomsDate,
    this.hospitalDate,
    this.hospitalDetails,
    this.illnessBiography,
    this.affectedPart,
    this.otherAffected,
    this.otherNames,
    this.additionalInfo,
    this.accidentLoc,
    this.accidentDate,
    this.accidentTime,
    this.accidentDay,
    this.hospitalHour,
    this.personName,
    this.transportMethod,
    this.accidentDesc,
    this.witnessName,
    this.injuryNumber,
    this.insideNetwork,
    this.accidentPeriod,
    this.wantInsurance,
    this.childSerialNo,
    this.complainantName,
    this.complainantPhoneNo,
    this.occupationText,
    this.clearanceNo,
    this.appStatusExternal,
    this.appStatusExternalDescAr,
    this.appStatusExternalDescEn,
    this.newAppFlag,
    this.lastEstNo,
    this.lastStodate,
    this.persNo,
    this.appStatusNote,
    this.approvedBy,
    this.lastUpdStatusDate,
    this.lastEstName,
    this.offno,
    this.corporationInjuryNo,
    this.corporationInjuryName,
    this.cashBankId,
    this.name,
    this.insuranceno,
    this.cMName1,
    this.cMName2,
    this.cMName3,
    this.cMName4,
    this.compInternationalcode,
    this.natNo,
    this.complainantNatNo,
    this.clearanceFlag,
    this.walletPassportNumber,
    this.walletPhone,
    this.walletPhoneVerivied,
    this.walletType,
    this.isDefense,
    this.bankName,
    this.branchName,
    this.accountName,
    this.actualStodate,
    this.civilWorkDoc,
    this.militaryWorkDoc,
    this.civMilRetiredDoc,
    this.paymentCountryCode,
    this.paymentPhone,
    this.ifsc,
    this.paymentCountry,
    this.penStartDate,
    this.secnoDead,
    this.netPay,
    this.typeOfAdvance,
    this.duration,
    this.outDebt,
    this.loanAmt,
    this.laonType,
    this.startdt,
    this.monthlyPayAmt,
    this.loanPaidAmt,
    this.totLoanAmt,
    this.governorate,
    this.cardno,
    this.nat,
    this.isArmy,
    this.marriageContract,
    this.childAppNo,
    this.regPer,
    this.vLoanAmount,
    this.vNetSalary,
    this.penIban,
    this.penTypeCode,
    this.totSalary,
    this.monthlyPayment,
    this.monthsPayCount,
    this.penTypeDesc,
    this.fullName,
    this.realtion,
    this.natNoDeath,
    this.deathDate,
    this.transactionType,
    this.deathBirthDate,
    this.placeOfDeath,
    this.personalSecno,
    this.personalNatNo,
    this.personalFullName,
    this.personalInternationalCode,
    this.personalRelativeType,
    this.injReason,
    this.transportMethodDesc,
  });

  int id;
  String applicationDate;
  dynamic applicationNum;
  int agreeTerms;
  dynamic appStatusInternal;
  dynamic appStatusInternalDescAr;
  dynamic appStatusInternalDescEn;
  dynamic approveDisclosure;
  dynamic notApproveReason;
  int applicantId;
  dynamic coorpId;
  dynamic coorpDesc;
  String applicantNo;
  int serviceType;
  String serviceTypeDescAr;
  String serviceTypeDescEn;
  dynamic bankLocation;
  int bankId;
  String bankDescAr;
  dynamic bankDescEn;
  int branchId;
  String iban;
  dynamic bankDetails;
  dynamic swiftCode;
  dynamic repNationality;
  dynamic repNationalNo;
  dynamic repName;
  dynamic receiptMethod;
  String phoneNumber;
  dynamic insuredAddress;
  dynamic maritalStatus;
  dynamic serviceSubType;
  int paymentMethod;
  String paymentMethodDescAr;
  String paymentMethodDescEn;
  dynamic otherDependants;
  dynamic sigAthorized;
  dynamic businessOwner;
  dynamic birthPlace;
  dynamic childNationality;
  dynamic childNatNo;
  dynamic birthDate;
  dynamic birthExpectation;
  dynamic leaveStartDate;
  dynamic leaveEndDate;
  dynamic inactiveReason;
  dynamic returnDate;
  dynamic compensationReason;
  dynamic compensationReasonDescAr;
  dynamic compensationReasonDescEn;
  dynamic occupationSubSid;
  dynamic jobDesc;
  dynamic symptoms;
  dynamic symptomsDate;
  dynamic hospitalDate;
  dynamic hospitalDetails;
  dynamic illnessBiography;
  dynamic affectedPart;
  dynamic otherAffected;
  dynamic otherNames;
  dynamic additionalInfo;
  dynamic accidentLoc;
  dynamic accidentDate;
  dynamic accidentTime;
  dynamic accidentDay;
  dynamic hospitalHour;
  dynamic personName;
  dynamic transportMethod;
  dynamic accidentDesc;
  dynamic witnessName;
  dynamic injuryNumber;
  dynamic insideNetwork;
  dynamic accidentPeriod;
  dynamic wantInsurance;
  dynamic childSerialNo;
  dynamic complainantName;
  dynamic complainantPhoneNo;
  dynamic occupationText;
  dynamic clearanceNo;
  int appStatusExternal;
  String appStatusExternalDescAr;
  String appStatusExternalDescEn;
  int newAppFlag;
  dynamic lastEstNo;
  String lastStodate;
  dynamic persNo;
  dynamic appStatusNote;
  dynamic approvedBy;
  dynamic lastUpdStatusDate;
  String lastEstName;
  int offno;
  dynamic corporationInjuryNo;
  dynamic corporationInjuryName;
  dynamic cashBankId;
  String name;
  int insuranceno;
  dynamic cMName1;
  dynamic cMName2;
  dynamic cMName3;
  dynamic cMName4;
  dynamic compInternationalcode;
  int natNo;
  dynamic complainantNatNo;
  dynamic clearanceFlag;
  dynamic walletPassportNumber;
  dynamic walletPhone;
  dynamic walletPhoneVerivied;
  dynamic walletType;
  dynamic isDefense;
  dynamic bankName;
  dynamic branchName;
  dynamic accountName;
  dynamic actualStodate;
  int civilWorkDoc;
  int militaryWorkDoc;
  int civMilRetiredDoc;
  dynamic paymentCountryCode;
  dynamic paymentPhone;
  dynamic ifsc;
  dynamic paymentCountry;
  dynamic penStartDate;
  dynamic secnoDead;
  dynamic netPay;
  dynamic typeOfAdvance;
  dynamic duration;
  dynamic outDebt;
  dynamic loanAmt;
  dynamic laonType;
  dynamic startdt;
  dynamic monthlyPayAmt;
  dynamic loanPaidAmt;
  dynamic totLoanAmt;
  dynamic governorate;
  dynamic cardno;
  int nat;
  dynamic isArmy;
  dynamic marriageContract;
  dynamic childAppNo;
  dynamic regPer;
  dynamic vLoanAmount;
  dynamic vNetSalary;
  dynamic penIban;
  dynamic penTypeCode;
  dynamic totSalary;
  dynamic monthlyPayment;
  dynamic monthsPayCount;
  dynamic penTypeDesc;
  String fullName;
  dynamic realtion;
  String natNoDeath;
  dynamic deathDate;
  dynamic transactionType;
  dynamic deathBirthDate;
  dynamic placeOfDeath;
  dynamic personalSecno;
  dynamic personalNatNo;
  dynamic personalFullName;
  dynamic personalInternationalCode;
  dynamic personalRelativeType;
  dynamic injReason;
  dynamic transportMethodDesc;

  factory PResult.fromJson(Map<String, dynamic> json) => PResult(
    id: json["ID"],
    applicationDate: json["APPLICATION_DATE"],
    applicationNum: json["APPLICATION_NUM"],
    agreeTerms: json["AGREE_TERMS"],
    appStatusInternal: json["APP_STATUS_INTERNAL"],
    appStatusInternalDescAr: json["APP_STATUS_INTERNAL_DESC_AR"],
    appStatusInternalDescEn: json["APP_STATUS_INTERNAL_DESC_EN"],
    approveDisclosure: json["APPROVE_DISCLOSURE"],
    notApproveReason: json["NOT_APPROVE_REASON"],
    applicantId: json["APPLICANT_ID"],
    coorpId: json["COORP_ID"],
    coorpDesc: json["COORP_DESC"],
    applicantNo: json["APPLICANT_NO"],
    serviceType: json["SERVICE_TYPE"],
    serviceTypeDescAr: json["SERVICE_TYPE_DESC_AR"],
    serviceTypeDescEn: json["SERVICE_TYPE_DESC_EN"],
    bankLocation: json["BANK_LOCATION"],
    bankId: json["BANK_ID"],
    bankDescAr: json["BANK_DESC_AR"],
    bankDescEn: json["BANK_DESC_EN"],
    branchId: json["BRANCH_ID"],
    iban: json["IBAN"],
    bankDetails: json["BANK_DETAILS"],
    swiftCode: json["SWIFT_CODE"],
    repNationality: json["REP_NATIONALITY"],
    repNationalNo: json["REP_NATIONAL_NO"],
    repName: json["REP_NAME"],
    receiptMethod: json["RECEIPT_METHOD"],
    phoneNumber: json["PHONE_NUMBER"],
    insuredAddress: json["INSURED_ADDRESS"],
    maritalStatus: json["MARITAL_STATUS"],
    serviceSubType: json["SERVICE_SUB_TYPE"],
    paymentMethod: json["PAYMENT_METHOD"],
    paymentMethodDescAr: json["PAYMENT_METHOD_DESC_AR"],
    paymentMethodDescEn: json["PAYMENT_METHOD_DESC_EN"],
    otherDependants: json["OTHER_DEPENDANTS"],
    sigAthorized: json["SIG_ATHORIZED"],
    businessOwner: json["BUSINESS_OWNER"],
    birthPlace: json["BIRTH_PLACE"],
    childNationality: json["CHILD_NATIONALITY"],
    childNatNo: json["CHILD_NAT_NO"],
    birthDate: json["BIRTH_DATE"],
    birthExpectation: json["BIRTH_EXPECTATION"],
    leaveStartDate: json["LEAVE_START_DATE"],
    leaveEndDate: json["LEAVE_END_DATE"],
    inactiveReason: json["INACTIVE_REASON"],
    returnDate: json["RETURN_DATE"],
    compensationReason: json["COMPENSATION_REASON"],
    compensationReasonDescAr: json["COMPENSATION_REASON_DESC_AR"],
    compensationReasonDescEn: json["COMPENSATION_REASON_DESC_EN"],
    occupationSubSid: json["OCCUPATION_SUB_SID"],
    jobDesc: json["JOB_DESC"],
    symptoms: json["SYMPTOMS"],
    symptomsDate: json["SYMPTOMS_DATE"],
    hospitalDate: json["HOSPITAL_DATE"],
    hospitalDetails: json["HOSPITAL_DETAILS"],
    illnessBiography: json["ILLNESS_BIOGRAPHY"],
    affectedPart: json["AFFECTED_PART"],
    otherAffected: json["OTHER_AFFECTED"],
    otherNames: json["OTHER_NAMES"],
    additionalInfo: json["ADDITIONAL_INFO"],
    accidentLoc: json["ACCIDENT_LOC"],
    accidentDate: json["ACCIDENT_DATE"],
    accidentTime: json["ACCIDENT_TIME"],
    accidentDay: json["ACCIDENT_DAY"],
    hospitalHour: json["HOSPITAL_HOUR"],
    personName: json["PERSON_NAME"],
    transportMethod: json["TRANSPORT_METHOD"],
    accidentDesc: json["ACCIDENT_DESC"],
    witnessName: json["WITNESS_NAME"],
    injuryNumber: json["INJURY_NUMBER"],
    insideNetwork: json["INSIDE_NETWORK"],
    accidentPeriod: json["ACCIDENT_PERIOD"],
    wantInsurance: json["WANT_INSURANCE"],
    childSerialNo: json["CHILD_SERIAL_NO"],
    complainantName: json["COMPLAINANT_NAME"],
    complainantPhoneNo: json["COMPLAINANT_PHONE_NO"],
    occupationText: json["OCCUPATION_TEXT"],
    clearanceNo: json["CLEARANCE_NO"],
    appStatusExternal: json["APP_STATUS_EXTERNAL"],
    appStatusExternalDescAr: json["APP_STATUS_EXTERNAL_DESC_AR"],
    appStatusExternalDescEn: json["APP_STATUS_EXTERNAL_DESC_EN"],
    newAppFlag: json["NEW_APP_FLAG"],
    lastEstNo: json["LAST_EST_NO"],
    lastStodate: json["LAST_STODATE"],
    persNo: json["PERS_NO"],
    appStatusNote: json["APP_STATUS_NOTE"],
    approvedBy: json["APPROVED_BY"],
    lastUpdStatusDate: json["LAST_UPD_STATUS_DATE"],
    lastEstName: json["LAST_EST_NAME"],
    offno: json["OFFNO"],
    corporationInjuryNo: json["CORPORATION_INJURY_NO"],
    corporationInjuryName: json["CORPORATION_INJURY_NAME"],
    cashBankId: json["CASH_BANK_ID"],
    name: json["NAME"],
    insuranceno: json["INSURANCENO"],
    cMName1: json["C_M_NAME1"],
    cMName2: json["C_M_NAME2"],
    cMName3: json["C_M_NAME3"],
    cMName4: json["C_M_NAME4"],
    compInternationalcode: json["COMP_INTERNATIONALCODE"],
    natNo: json["NAT_NO"],
    complainantNatNo: json["COMPLAINANT_NAT_NO"],
    clearanceFlag: json["CLEARANCE_FLAG"],
    walletPassportNumber: json["WALLET_PASSPORT_NUMBER"],
    walletPhone: json["WALLET_PHONE"],
    walletPhoneVerivied: json["WALLET_PHONE_VERIVIED"],
    walletType: json["WALLET_TYPE"],
    isDefense: json["IS_DEFENSE"],
    bankName: json["BANK_NAME"],
    branchName: json["BRANCH_NAME"],
    accountName: json["ACCOUNT_NAME"],
    actualStodate: json["ACTUAL_STODATE"],
    civilWorkDoc: json["CIVIL_WORK_DOC"],
    militaryWorkDoc: json["MILITARY_WORK_DOC"],
    civMilRetiredDoc: json["CIV_MIL_RETIRED_DOC"],
    paymentCountryCode: json["PAYMENT_COUNTRY_CODE"],
    paymentPhone: json["PAYMENT_PHONE"],
    ifsc: json["IFSC"],
    paymentCountry: json["PAYMENT_COUNTRY"],
    penStartDate: json["PEN_START_DATE"],
    secnoDead: json["SECNO_DEAD"],
    netPay: json["NET_PAY"],
    typeOfAdvance: json["TYPE_OF_ADVANCE"],
    duration: json["DURATION"],
    outDebt: json["OUT_DEBT"],
    loanAmt: json["LOAN_AMT"],
    laonType: json["LAON_TYPE"],
    startdt: json["STARTDT"],
    monthlyPayAmt: json["MONTHLY_PAY_AMT"],
    loanPaidAmt: json["LOAN_PAID_AMT"],
    totLoanAmt: json["TOT_LOAN_AMT"],
    governorate: json["GOVERNORATE"],
    cardno: json["CARDNO"],
    nat: json["NAT"],
    isArmy: json["IS_ARMY"],
    marriageContract: json["Marriage_contract"],
    childAppNo: json["CHILD_APP_NO"],
    regPer: json["REG_PER"],
    vLoanAmount: json["V_LOAN_AMOUNT"],
    vNetSalary: json["V_NET_SALARY"],
    penIban: json["PEN_IBAN"],
    penTypeCode: json["PEN_TYPE_CODE"],
    totSalary: json["TOT_SALARY"],
    monthlyPayment: json["MONTHLY_PAYMENT"],
    monthsPayCount: json["MONTHS_PAY_COUNT"],
    penTypeDesc: json["PEN_TYPE_DESC"],
    fullName: json["FULL_NAME"],
    realtion: json["REALTION"],
    natNoDeath: json["NAT_NO_DEATH"],
    deathDate: json["DEATH_DATE"],
    transactionType: json["TRANSACTION_TYPE"],
    deathBirthDate: json["DEATH_BIRTH_DATE"],
    placeOfDeath: json["PLACE_OF_DEATH"],
    personalSecno: json["PERSONAL_SECNO"],
    personalNatNo: json["PERSONAL_NAT_NO"],
    personalFullName: json["PERSONAL_FULL_NAME"],
    personalInternationalCode: json["PERSONAL_INTERNATIONAL_CODE"],
    personalRelativeType: json["PERSONAL_RELATIVE_TYPE"],
    injReason: json["INJ_REASON"],
    transportMethodDesc: json["TRANSPORT_METHOD_DESC"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "APPLICATION_DATE": applicationDate,
    "APPLICATION_NUM": applicationNum,
    "AGREE_TERMS": agreeTerms,
    "APP_STATUS_INTERNAL": appStatusInternal,
    "APP_STATUS_INTERNAL_DESC_AR": appStatusInternalDescAr,
    "APP_STATUS_INTERNAL_DESC_EN": appStatusInternalDescEn,
    "APPROVE_DISCLOSURE": approveDisclosure,
    "NOT_APPROVE_REASON": notApproveReason,
    "APPLICANT_ID": applicantId,
    "COORP_ID": coorpId,
    "COORP_DESC": coorpDesc,
    "APPLICANT_NO": applicantNo,
    "SERVICE_TYPE": serviceType,
    "SERVICE_TYPE_DESC_AR": serviceTypeDescAr,
    "SERVICE_TYPE_DESC_EN": serviceTypeDescEn,
    "BANK_LOCATION": bankLocation,
    "BANK_ID": bankId,
    "BANK_DESC_AR": bankDescAr,
    "BANK_DESC_EN": bankDescEn,
    "BRANCH_ID": branchId,
    "IBAN": iban,
    "BANK_DETAILS": bankDetails,
    "SWIFT_CODE": swiftCode,
    "REP_NATIONALITY": repNationality,
    "REP_NATIONAL_NO": repNationalNo,
    "REP_NAME": repName,
    "RECEIPT_METHOD": receiptMethod,
    "PHONE_NUMBER": phoneNumber,
    "INSURED_ADDRESS": insuredAddress,
    "MARITAL_STATUS": maritalStatus,
    "SERVICE_SUB_TYPE": serviceSubType,
    "PAYMENT_METHOD": paymentMethod,
    "PAYMENT_METHOD_DESC_AR": paymentMethodDescAr,
    "PAYMENT_METHOD_DESC_EN": paymentMethodDescEn,
    "OTHER_DEPENDANTS": otherDependants,
    "SIG_ATHORIZED": sigAthorized,
    "BUSINESS_OWNER": businessOwner,
    "BIRTH_PLACE": birthPlace,
    "CHILD_NATIONALITY": childNationality,
    "CHILD_NAT_NO": childNatNo,
    "BIRTH_DATE": birthDate,
    "BIRTH_EXPECTATION": birthExpectation,
    "LEAVE_START_DATE": leaveStartDate,
    "LEAVE_END_DATE": leaveEndDate,
    "INACTIVE_REASON": inactiveReason,
    "RETURN_DATE": returnDate,
    "COMPENSATION_REASON": compensationReason,
    "COMPENSATION_REASON_DESC_AR": compensationReasonDescAr,
    "COMPENSATION_REASON_DESC_EN": compensationReasonDescEn,
    "OCCUPATION_SUB_SID": occupationSubSid,
    "JOB_DESC": jobDesc,
    "SYMPTOMS": symptoms,
    "SYMPTOMS_DATE": symptomsDate,
    "HOSPITAL_DATE": hospitalDate,
    "HOSPITAL_DETAILS": hospitalDetails,
    "ILLNESS_BIOGRAPHY": illnessBiography,
    "AFFECTED_PART": affectedPart,
    "OTHER_AFFECTED": otherAffected,
    "OTHER_NAMES": otherNames,
    "ADDITIONAL_INFO": additionalInfo,
    "ACCIDENT_LOC": accidentLoc,
    "ACCIDENT_DATE": accidentDate,
    "ACCIDENT_TIME": accidentTime,
    "ACCIDENT_DAY": accidentDay,
    "HOSPITAL_HOUR": hospitalHour,
    "PERSON_NAME": personName,
    "TRANSPORT_METHOD": transportMethod,
    "ACCIDENT_DESC": accidentDesc,
    "WITNESS_NAME": witnessName,
    "INJURY_NUMBER": injuryNumber,
    "INSIDE_NETWORK": insideNetwork,
    "ACCIDENT_PERIOD": accidentPeriod,
    "WANT_INSURANCE": wantInsurance,
    "CHILD_SERIAL_NO": childSerialNo,
    "COMPLAINANT_NAME": complainantName,
    "COMPLAINANT_PHONE_NO": complainantPhoneNo,
    "OCCUPATION_TEXT": occupationText,
    "CLEARANCE_NO": clearanceNo,
    "APP_STATUS_EXTERNAL": appStatusExternal,
    "APP_STATUS_EXTERNAL_DESC_AR": appStatusExternalDescAr,
    "APP_STATUS_EXTERNAL_DESC_EN": appStatusExternalDescEn,
    "NEW_APP_FLAG": newAppFlag,
    "LAST_EST_NO": lastEstNo,
    "LAST_STODATE": lastStodate,
    "PERS_NO": persNo,
    "APP_STATUS_NOTE": appStatusNote,
    "APPROVED_BY": approvedBy,
    "LAST_UPD_STATUS_DATE": lastUpdStatusDate,
    "LAST_EST_NAME": lastEstName,
    "OFFNO": offno,
    "CORPORATION_INJURY_NO": corporationInjuryNo,
    "CORPORATION_INJURY_NAME": corporationInjuryName,
    "CASH_BANK_ID": cashBankId,
    "NAME": name,
    "INSURANCENO": insuranceno,
    "C_M_NAME1": cMName1,
    "C_M_NAME2": cMName2,
    "C_M_NAME3": cMName3,
    "C_M_NAME4": cMName4,
    "COMP_INTERNATIONALCODE": compInternationalcode,
    "NAT_NO": natNo,
    "COMPLAINANT_NAT_NO": complainantNatNo,
    "CLEARANCE_FLAG": clearanceFlag,
    "WALLET_PASSPORT_NUMBER": walletPassportNumber,
    "WALLET_PHONE": walletPhone,
    "WALLET_PHONE_VERIVIED": walletPhoneVerivied,
    "WALLET_TYPE": walletType,
    "IS_DEFENSE": isDefense,
    "BANK_NAME": bankName,
    "BRANCH_NAME": branchName,
    "ACCOUNT_NAME": accountName,
    "ACTUAL_STODATE": actualStodate,
    "CIVIL_WORK_DOC": civilWorkDoc,
    "MILITARY_WORK_DOC": militaryWorkDoc,
    "CIV_MIL_RETIRED_DOC": civMilRetiredDoc,
    "PAYMENT_COUNTRY_CODE": paymentCountryCode,
    "PAYMENT_PHONE": paymentPhone,
    "IFSC": ifsc,
    "PAYMENT_COUNTRY": paymentCountry,
    "PEN_START_DATE": penStartDate,
    "SECNO_DEAD": secnoDead,
    "NET_PAY": netPay,
    "TYPE_OF_ADVANCE": typeOfAdvance,
    "DURATION": duration,
    "OUT_DEBT": outDebt,
    "LOAN_AMT": loanAmt,
    "LAON_TYPE": laonType,
    "STARTDT": startdt,
    "MONTHLY_PAY_AMT": monthlyPayAmt,
    "LOAN_PAID_AMT": loanPaidAmt,
    "TOT_LOAN_AMT": totLoanAmt,
    "GOVERNORATE": governorate,
    "CARDNO": cardno,
    "NAT": nat,
    "IS_ARMY": isArmy,
    "Marriage_contract": marriageContract,
    "CHILD_APP_NO": childAppNo,
    "REG_PER": regPer,
    "V_LOAN_AMOUNT": vLoanAmount,
    "V_NET_SALARY": vNetSalary,
    "PEN_IBAN": penIban,
    "PEN_TYPE_CODE": penTypeCode,
    "TOT_SALARY": totSalary,
    "MONTHLY_PAYMENT": monthlyPayment,
    "MONTHS_PAY_COUNT": monthsPayCount,
    "PEN_TYPE_DESC": penTypeDesc,
    "FULL_NAME": fullName,
    "REALTION": realtion,
    "NAT_NO_DEATH": natNoDeath,
    "DEATH_DATE": deathDate,
    "TRANSACTION_TYPE": transactionType,
    "DEATH_BIRTH_DATE": deathBirthDate,
    "PLACE_OF_DEATH": placeOfDeath,
    "PERSONAL_SECNO": personalSecno,
    "PERSONAL_NAT_NO": personalNatNo,
    "PERSONAL_FULL_NAME": personalFullName,
    "PERSONAL_INTERNATIONAL_CODE": personalInternationalCode,
    "PERSONAL_RELATIVE_TYPE": personalRelativeType,
    "INJ_REASON": injReason,
    "TRANSPORT_METHOD_DESC": transportMethodDesc,
  };
}
