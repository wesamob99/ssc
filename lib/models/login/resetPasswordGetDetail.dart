// To parse this JSON data, do
//
//     final resetPasswordGetDetail = resetPasswordGetDetailFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

ResetPasswordGetDetail resetPasswordGetDetailFromJson(String str) => ResetPasswordGetDetail.fromJson(json.decode(str));

String resetPasswordGetDetailToJson(ResetPasswordGetDetail data) => json.encode(data.toJson());

class ResetPasswordGetDetail {
  ResetPasswordGetDetail({
    this.poEmail,
    this.poInternationalcode,
    this.poMobileno,
    this.poRealMobileno,
    this.poStatus,
    this.poStatusDescAr,
    this.poStatusDescEn,
    this.poUserGroup,
    this.poNationality,
  });

  final String poEmail;
  final dynamic poInternationalcode;
  final String poMobileno;
  final dynamic poRealMobileno;
  final int poStatus;
  final String poStatusDescAr;
  final String poStatusDescEn;
  final dynamic poUserGroup;
  final dynamic poNationality;

  factory ResetPasswordGetDetail.fromJson(Map<String, dynamic> json) => ResetPasswordGetDetail(
    poEmail: json["PO_EMAIL"],
    poInternationalcode: json["PO_INTERNATIONALCODE"],
    poMobileno: json["PO_MOBILENO"],
    poRealMobileno: json["PO_REAL_MOBILENO"],
    poStatus: json["PO_STATUS"],
    poStatusDescAr: json["PO_STATUS_DESC_AR"],
    poStatusDescEn: json["PO_STATUS_DESC_EN"],
    poUserGroup: json["PO_USER_GROUP"],
    poNationality: json["PO_NATIONALITY"],
  );

  Map<String, dynamic> toJson() => {
    "PO_EMAIL": poEmail,
    "PO_INTERNATIONALCODE": poInternationalcode,
    "PO_MOBILENO": poMobileno,
    "PO_REAL_MOBILENO": poRealMobileno,
    "PO_STATUS": poStatus,
    "PO_STATUS_DESC_AR": poStatusDescAr,
    "PO_STATUS_DESC_EN": poStatusDescEn,
    "PO_USER_GROUP": poUserGroup,
    "PO_NATIONALITY": poNationality,
  };
}
