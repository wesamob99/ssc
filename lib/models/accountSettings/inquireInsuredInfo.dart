// To parse this JSON data, do
//
//     final inquireInsuredInfoModel = inquireInsuredInfoModelFromJson(jsonString);

import 'dart:convert';

InquireInsuredInfoModel inquireInsuredInfoModelFromJson(String str) => InquireInsuredInfoModel.fromJson(json.decode(str));

String inquireInsuredInfoModelToJson(InquireInsuredInfoModel data) => json.encode(data.toJson());

class InquireInsuredInfoModel {
  InquireInsuredInfoModel({
    this.poStatusNo,
    this.pOStatusDescAr,
    this.pOStatusDescEn,
    this.curGetdata,
    this.curGetdata2,
    this.curGetdata3,
  });

  int poStatusNo;
  dynamic pOStatusDescAr;
  dynamic pOStatusDescEn;
  List<List<CurGetdatum>> curGetdata;
  List<List<CurGetdata2>> curGetdata2;
  List<List<CurGetdata3>> curGetdata3;

  factory InquireInsuredInfoModel.fromJson(Map<String, dynamic> json) => InquireInsuredInfoModel(
    poStatusNo: json["PO_status_no"],
    pOStatusDescAr: json["pO_status_desc_ar"],
    pOStatusDescEn: json["pO_status_desc_en"],
    curGetdata: List<List<CurGetdatum>>.from(json["cur_getdata"].map((x) => List<CurGetdatum>.from(x.map((x) => CurGetdatum.fromJson(x))))),
    curGetdata2: List<List<CurGetdata2>>.from(json["cur_getdata2"].map((x) => List<CurGetdata2>.from(x.map((x) => CurGetdata2.fromJson(x))))),
    curGetdata3: List<List<CurGetdata3>>.from(json["cur_getdata3"].map((x) => List<CurGetdata3>.from(x.map((x) => CurGetdata3.fromJson(x))))),
  );

  Map<String, dynamic> toJson() => {
    "PO_status_no": poStatusNo,
    "pO_status_desc_ar": pOStatusDescAr,
    "pO_status_desc_en": pOStatusDescEn,
    "cur_getdata": List<dynamic>.from(curGetdata.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
    "cur_getdata2": List<dynamic>.from(curGetdata2.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
    "cur_getdata3": List<dynamic>.from(curGetdata3.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
  };
}

class CurGetdatum {
  CurGetdatum({
    this.secno,
    this.natNo,
    this.name1,
    this.name2,
    this.name3,
    this.name4,
    this.sex,
    this.dob,
    this.nat,
    this.regdate,
    this.dedsal,
    this.corp,
    this.curcorp,
  });

  int secno;
  int natNo;
  String name1;
  String name2;
  String name3;
  String name4;
  String sex;
  String dob;
  String nat;
  String regdate;
  String dedsal;
  Corp corp;
  Corp curcorp;

  factory CurGetdatum.fromJson(Map<String, dynamic> json) => CurGetdatum(
    secno: json["SECNO"],
    natNo: json["NAT_NO"],
    name1: json["NAME1"],
    name2: json["NAME2"],
    name3: json["NAME3"],
    name4: json["NAME4"],
    sex: json["SEX"],
    dob: json["DOB"],
    nat: json["NAT"],
    regdate: json["REGDATE"],
    dedsal: json["DEDSAL"],
    corp: corpValues.map[json["CORP"]],
    curcorp: corpValues.map[json["CURCORP"]],
  );

  Map<String, dynamic> toJson() => {
    "SECNO": secno,
    "NAT_NO": natNo,
    "NAME1": name1,
    "NAME2": name2,
    "NAME3": name3,
    "NAME4": name4,
    "SEX": sex,
    "DOB": dob,
    "NAT": nat,
    "REGDATE": regdate,
    "DEDSAL": dedsal,
    "CORP": corpValues.reverse[corp],
    "CURCORP": corpValues.reverse[curcorp],
  };
}

enum Corp { EMPTY, CORP }

final corpValues = EnumValues({
  "وزاره الصحه": Corp.CORP,
  "خضوع الاختيارى": Corp.EMPTY
});

class CurGetdata2 {
  CurGetdata2({
    this.stadate,
    this.salary,
    this.stodate,
    this.descr,
    this.estno,
    this.ename,
    this.approveDesc,
    this.monthCount,
  });

  String stadate;
  String salary;
  String stodate;
  String descr;
  int estno;
  Corp ename;
  dynamic approveDesc;
  int monthCount;

  factory CurGetdata2.fromJson(Map<String, dynamic> json) => CurGetdata2(
    stadate: json["STADATE"],
    salary: json["SALARY"],
    stodate: json["STODATE"],
    descr: json["descr"],
    estno: json["ESTNO"],
    ename: corpValues.map[json["ename"]],
    approveDesc: json["APPROVE_DESC"],
    monthCount: json["MONTH_COUNT"],
  );

  Map<String, dynamic> toJson() => {
    "STADATE": stadate,
    "SALARY": salary,
    "STODATE": stodate,
    "descr": descr,
    "ESTNO": estno,
    "ename": corpValues.reverse[ename],
    "APPROVE_DESC": approveDesc,
    "MONTH_COUNT": monthCount,
  };
}

class CurGetdata3 {
  CurGetdata3({
    this.year,
    this.sal,
    this.est,
    this.ename,
    this.approveDesc,
  });

  int year;
  String sal;
  int est;
  Corp ename;
  dynamic approveDesc;

  factory CurGetdata3.fromJson(Map<String, dynamic> json) => CurGetdata3(
    year: json["YEAR"],
    sal: json["SAL"],
    est: json["EST"],
    ename: corpValues.map[json["ename"]],
    approveDesc: json["APPROVE_DESC"],
  );

  Map<String, dynamic> toJson() => {
    "YEAR": year,
    "SAL": sal,
    "EST": est,
    "ename": corpValues.reverse[ename],
    "APPROVE_DESC": approveDesc,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
