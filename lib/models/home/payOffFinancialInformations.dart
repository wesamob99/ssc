// To parse this JSON data, do
//
//     final payOffFinancialInformation = payOffFinancialInformationFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

PayOffFinancialInformation payOffFinancialInformationFromJson(String str) => PayOffFinancialInformation.fromJson(json.decode(str));

String payOffFinancialInformationToJson(PayOffFinancialInformation data) => json.encode(data.toJson());

class PayOffFinancialInformation {
  PayOffFinancialInformation({
    this.instrucCur,
    this.infoCur,
    this.mainPayCur,
    this.subPayCur,
    this.poStatus,
    this.poStatusType,
    this.poStatusDescAr,
    this.poStatusDescEn,
    this.success,
  });

  final List<List<String>> instrucCur;
  final List<List<InfoCur>> infoCur;
  final List<List<MainPayCur>> mainPayCur;
  final List<List<SubPayCur>> subPayCur;
  final int poStatus;
  final int poStatusType;
  final String poStatusDescAr;
  final String poStatusDescEn;
  final bool success;

  factory PayOffFinancialInformation.fromJson(Map<String, dynamic> json) => PayOffFinancialInformation(
    instrucCur: json["INSTRUC_CUR"] == null ? null : List<List<String>>.from(json["INSTRUC_CUR"].map((x) => List<String>.from(x.map((x) => x)))),
    infoCur: json["INFO_CUR"] == null ? null : List<List<InfoCur>>.from(json["INFO_CUR"].map((x) => List<InfoCur>.from(x.map((x) => InfoCur.fromJson(x))))),
    mainPayCur: json["MAIN_PAY_CUR"] == null ? null : List<List<MainPayCur>>.from(json["MAIN_PAY_CUR"].map((x) => List<MainPayCur>.from(x.map((x) => MainPayCur.fromJson(x))))),
    subPayCur: json["SUB_PAY_CUR"] == null ? null : List<List<SubPayCur>>.from(json["SUB_PAY_CUR"].map((x) => List<SubPayCur>.from(x.map((x) => SubPayCur.fromJson(x))))),
    poStatus: json["PO_STATUS"],
    poStatusType: json["PO_STATUS_TYPE"],
    poStatusDescAr: json["PO_STATUS_DESC_AR"],
    poStatusDescEn: json["PO_STATUS_DESC_EN"],
  );

  Map<String, dynamic> toJson() => {
    "INSTRUC_CUR": instrucCur == null ? null : List<dynamic>.from(instrucCur.map((x) => List<dynamic>.from(x.map((x) => x)))),
    "INFO_CUR": infoCur == null ? null : List<dynamic>.from(infoCur.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
    "MAIN_PAY_CUR": mainPayCur == null ? null : List<dynamic>.from(mainPayCur.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
    "SUB_PAY_CUR": subPayCur == null ? null : List<dynamic>.from(subPayCur.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
    "PO_STATUS": poStatus,
    "PO_STATUS_TYPE": poStatusType,
    "PO_STATUS_DESC_AR": poStatusDescAr,
    "PO_STATUS_DESC_EN": poStatusDescEn,
    "success": success,
  };
}

class InfoCur {
  InfoCur({
    this.insuredNo,
    this.insuredNat,
    this.name,
    this.amount,
  });

  final int insuredNo;
  final int insuredNat;
  final String name;
  final dynamic amount;

  factory InfoCur.fromJson(Map<String, dynamic> json) => InfoCur(
    insuredNo: json["INSURED_NO"],
    insuredNat: json["INSURED_NAT"],
    name: json["NAME"],
    amount: json["AMOUNT"],
  );

  Map<String, dynamic> toJson() => {
    "INSURED_NO": insuredNo,
    "INSURED_NAT": insuredNat,
    "NAME": name,
    "AMOUNT": amount,
  };
}

class MainPayCur {
  MainPayCur({
    this.id,
    this.descr,
    this.amt,
  });

  final int id;
  final String descr;
  final dynamic amt;

  factory MainPayCur.fromJson(Map<String, dynamic> json) => MainPayCur(
    id: json["ID"],
    descr: json["DESCR"],
    amt: json["AMT"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "DESCR": descr,
    "AMT": amt,
  };
}

class SubPayCur {
  SubPayCur({
    this.mainType,
    this.subType,
    this.subTypeDesc,
    this.yearId,
    this.chkDate,
    this.chkNo,
    this.chkAmt,
    this.due,
    this.reasonId,
    this.payNo,
    this.seq,
  });

  final int mainType;
  final int subType;
  final String subTypeDesc;
  final dynamic yearId;
  final String chkDate;
  final dynamic chkNo;
  final dynamic chkAmt;
  final String due;
  final dynamic reasonId;
  final dynamic payNo;
  final dynamic seq;

  bool isChecked = false;

  factory SubPayCur.fromJson(Map<String, dynamic> json) => SubPayCur(
    mainType: json["MAIN_TYPE"],
    subType: json["SUB_TYPE"],
    subTypeDesc: json["SUB_TYPE_DESC"],
    yearId: json["YEAR_ID"],
    chkDate: json["CHK_DATE"],
    chkNo: json["CHK_NO"],
    chkAmt: json["CHK_AMT"],
    due: json["DUE"],
    reasonId: json["REASON_ID"],
    payNo: json["PAY_NO"],
    seq: json["SEQ"],
  );

  Map<String, dynamic> toJson() => {
    "MAIN_TYPE": mainType,
    "SUB_TYPE": subType,
    "SUB_TYPE_DESC": subTypeDesc,
    "YEAR_ID": yearId,
    "CHK_DATE": chkDate,
    "CHK_NO": chkNo,
    "CHK_AMT": chkAmt,
    "DUE": due,
    "REASON_ID": reasonId,
    "PAY_NO": payNo,
    "SEQ": seq,
  };
}
