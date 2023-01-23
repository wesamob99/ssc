// To parse this JSON data, do
//
//     registerData = registerDataFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

RegisterData registerDataFromJson(String str) => RegisterData.fromJson(json.decode(str));

String registerDataToJson(RegisterData data) => json.encode(data.toJson());

class RegisterData {
  RegisterData({
    this.nationality,
    this.nationalNumber,
    this.personalNumber,
    this.personalCardNo,
    this.relativeNatId,
    this.relativeType,
    this.gender,
    this.dateOfBirth,
    this.countryCodeNo,
    this.mobileNo,
    this.passportNo,
    this.dateOfEntry,
    this.insuranceNo,
    this.residentCountry,
    this.academicLevel,
    this.email,
    this.confirmEmail,
    this.bankCode,
    this.iban,
    this.password,
    this.userId,
    this.activationBy,
    this.language,
    this.recaptchaReactive,
    this.nationalId,
    this.nationalMobile,
    this.nationalMobileCode,
    this.hashedCaptcha,
    this.isWebsite,
  });

  int nationality;
  dynamic nationalNumber;
  dynamic personalNumber;
  String personalCardNo;
  int relativeNatId;
  int relativeType;
  dynamic gender;
  dynamic dateOfBirth;
  String countryCodeNo;
  String mobileNo;
  dynamic passportNo;
  dynamic dateOfEntry;
  dynamic insuranceNo;
  int residentCountry;
  String academicLevel;
  String email;
  String confirmEmail;
  dynamic bankCode;
  dynamic iban;
  String password;
  dynamic userId;
  int activationBy;
  int language;
  String recaptchaReactive;
  dynamic nationalId;
  dynamic nationalMobile;
  dynamic nationalMobileCode;
  String hashedCaptcha;
  bool isWebsite;

  factory RegisterData.fromJson(Map<String, dynamic> json) => RegisterData(
    nationality: json["nationality"],
    nationalNumber: json["nationalNumber"],
    personalNumber: json["personalNumber"],
    personalCardNo: json["personalCardNo"],
    relativeNatId: json["relativeNatId"],
    relativeType: json["relativeType"],
    gender: json["gender"],
    dateOfBirth: json["dateOfBirth"],
    countryCodeNo: json["countryCodeNo"],
    mobileNo: json["mobileNo"],
    passportNo: json["passportNo"],
    dateOfEntry: json["dateOfEntry"],
    insuranceNo: json["insuranceNo"],
    residentCountry: json["residentCountry"],
    academicLevel: json["academicLevel"],
    email: json["email"],
    confirmEmail: json["confirmEmail"],
    bankCode: json["bankCode"],
    iban: json["iban"],
    password: json["password"],
    userId: json["userId"],
    activationBy: json["activationBy"],
    language: json["language"],
    recaptchaReactive: json["recaptchaReactive"],
    nationalId: json["nationalID"],
    nationalMobile: json["nationalMobile"],
    nationalMobileCode: json["nationalMobileCode"],
    hashedCaptcha: json["hashedCaptcha"],
    isWebsite: json["isWebsite"],
  );

  Map<String, dynamic> toJson() => {
    "nationality": nationality,
    "nationalNumber": nationalNumber,
    "personalNumber": personalNumber,
    "personalCardNo": personalCardNo,
    "relativeNatId": relativeNatId,
    "relativeType": relativeType,
    "gender": gender,
    "dateOfBirth": dateOfBirth,
    "countryCodeNo": countryCodeNo,
    "mobileNo": mobileNo,
    "passportNo": passportNo,
    "dateOfEntry": dateOfEntry,
    "insuranceNo": insuranceNo,
    "residentCountry": residentCountry,
    "academicLevel": academicLevel,
    "email": email,
    "confirmEmail": confirmEmail,
    "bankCode": bankCode,
    "iban": iban,
    "password": password,
    "userId": userId,
    "activationBy": activationBy,
    "language": language,
    "recaptchaReactive": recaptchaReactive,
    "nationalID": nationalId,
    "nationalMobile": nationalMobile,
    "nationalMobileCode": nationalMobileCode,
    "hashedCaptcha": hashedCaptcha,
    "isWebsite": isWebsite,
  };
}
