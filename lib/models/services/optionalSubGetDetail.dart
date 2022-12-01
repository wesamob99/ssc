// To parse this JSON data, do
//
//     final optionalSubGetDetail = optionalSubGetDetailFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

OptionalSubGetDetail optionalSubGetDetailFromJson(String str) => OptionalSubGetDetail.fromJson(json.decode(str));

String optionalSubGetDetailToJson(OptionalSubGetDetail data) => json.encode(data.toJson());

class OptionalSubGetDetail {
  OptionalSubGetDetail({
    this.poIsItFirstOptionalSub,
    this.poStatusNo,
    this.pOStatusDescAr,
    this.pOStatusDescEn,
    this.curGetdata,
  });

  int poIsItFirstOptionalSub;
  int poStatusNo;
  dynamic pOStatusDescAr;
  dynamic pOStatusDescEn;
  List<List<CurGetdatum2>> curGetdata;

  factory OptionalSubGetDetail.fromJson(Map<String, dynamic> json) => OptionalSubGetDetail(
    poIsItFirstOptionalSub: json["PO_is_it_firstOptionalSub"],
    poStatusNo: json["PO_status_no"],
    pOStatusDescAr: json["pO_status_desc_ar"],
    pOStatusDescEn: json["pO_status_desc_en"],
    curGetdata: json["cur_getdata"] == null ? null : List<List<CurGetdatum2>>.from(json["cur_getdata"].map((x) => List<CurGetdatum2>.from(x.map((x) => CurGetdatum2.fromJson(x))))),
  );

  Map<String, dynamic> toJson() => {
    "PO_is_it_firstOptionalSub": poIsItFirstOptionalSub,
    "PO_status_no": poStatusNo,
    "pO_status_desc_ar": pOStatusDescAr,
    "pO_status_desc_en": pOStatusDescEn,
    "cur_getdata": curGetdata == null ? null : List<dynamic>.from(curGetdata.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
  };
}

class CurGetdatum2 {
  CurGetdatum2({
    this.secno,
    this.name1,
    this.name2,
    this.name3,
    this.name4,
    this.dob,
    this.mname1,
    this.natNo,
    this.sex,
    this.mobile,
    this.internationalCode,
    this.email,
    this.address,
    this.regDate,
    this.lastSalary,
    this.fileNo,
    this.hasbenefitofdec,
    this.hasbenefitofinc,
    this.noofincrements,
    this.maxPerOfInc,
    this.minimumsalaryforchoose,
    this.minimumsalaryfordec,
    this.maximumsalaryforchoose,
    this.maximumsalaryfordec,
    this.regPer,
    this.avgsalary,
    this.livelocation,
    this.referanceMobile,
    this.branch,
    this.complementarySubsc,
    this.lastSalOptEnabled,
  });

  int secno;
  String name1;
  String name2;
  String name3;
  String name4;
  String dob;
  String mname1;
  int natNo;
  String sex;
  int mobile;
  int internationalCode;
  String email;
  String address;
  String regDate;
  int lastSalary;
  String fileNo;
  int hasbenefitofdec;
  int hasbenefitofinc;
  int noofincrements;
  int maxPerOfInc;
  int minimumsalaryforchoose;
  int minimumsalaryfordec;
  int maximumsalaryforchoose;
  int maximumsalaryfordec;
  String regPer;
  int avgsalary;
  int livelocation;
  double referanceMobile;
  int branch;
  int complementarySubsc;
  int lastSalOptEnabled;

  factory CurGetdatum2.fromJson(Map<String, dynamic> json) => CurGetdatum2(
    secno: json["SECNO"],
    name1: json["NAME1"],
    name2: json["NAME2"],
    name3: json["NAME3"],
    name4: json["NAME4"],
    dob: json["DOB"],
    mname1: json["MNAME1"],
    natNo: json["NAT_NO"],
    sex: json["SEX"],
    mobile: json["MOBILE"],
    internationalCode: json["INTERNATIONAL_CODE"],
    email: json["EMAIL"],
    address: json["ADDRESS"],
    regDate: json["REG_DATE"],
    lastSalary: json["LAST_SALARY"],
    fileNo: json["FILE_NO"],
    hasbenefitofdec: json["HASBENEFITOFDEC"],
    hasbenefitofinc: json["HASBENEFITOFINC"],
    noofincrements: json["NOOFINCREMENTS"],
    maxPerOfInc: json["MAX_PER_OF_INC"],
    minimumsalaryforchoose: json["MINIMUMSALARYFORCHOOSE"],
    minimumsalaryfordec: json["MINIMUMSALARYFORDEC"],
    maximumsalaryforchoose: json["MAXIMUMSALARYFORCHOOSE"],
    maximumsalaryfordec: json["MAXIMUMSALARYFORDEC"],
    regPer: json["REG_PER"],
    avgsalary: json["AVGSALARY"],
    livelocation: json["LIVELOCATION"],
    // ignore: prefer_null_aware_operators
    referanceMobile: json["REFERANCE_MOBILE"] == null ? null : json["REFERANCE_MOBILE"].toDouble(),
    branch: json["BRANCH"],
    complementarySubsc: json["COMPLEMENTARY_SUBSC"],
    lastSalOptEnabled: json["LAST_SAL_OPT_ENABLED"],
  );

  Map<String, dynamic> toJson() => {
    "SECNO": secno,
    "NAME1": name1,
    "NAME2": name2,
    "NAME3": name3,
    "NAME4": name4,
    "DOB": dob,
    "MNAME1": mname1,
    "NAT_NO": natNo,
    "SEX": sex,
    "MOBILE": mobile,
    "INTERNATIONAL_CODE": internationalCode,
    "EMAIL": email,
    "ADDRESS": address,
    "REG_DATE": regDate,
    "LAST_SALARY": lastSalary,
    "FILE_NO": fileNo,
    "HASBENEFITOFDEC": hasbenefitofdec,
    "HASBENEFITOFINC": hasbenefitofinc,
    "NOOFINCREMENTS": noofincrements,
    "MAX_PER_OF_INC": maxPerOfInc,
    "MINIMUMSALARYFORCHOOSE": minimumsalaryforchoose,
    "MINIMUMSALARYFORDEC": minimumsalaryfordec,
    "MAXIMUMSALARYFORCHOOSE": maximumsalaryforchoose,
    "MAXIMUMSALARYFORDEC": maximumsalaryfordec,
    "REG_PER": regPer,
    "AVGSALARY": avgsalary,
    "LIVELOCATION": livelocation,
    "REFERANCE_MOBILE": referanceMobile,
    "BRANCH": branch,
    "COMPLEMENTARY_SUBSC": complementarySubsc,
    "LAST_SAL_OPT_ENABLED": lastSalOptEnabled,
  };
}
