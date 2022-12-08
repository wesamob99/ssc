// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../models/home/payOffFinancialInformations.dart';
import '../../model/pay/payRepository.dart';

class PayProvider extends ChangeNotifier {

  PayRepository payRepository = PayRepository();
  bool isLoading = false;

  Future issuanceOfUnifiedPaymentCode(List<SubPayCur> payments) async{
    List<String> data = [];
    for (var element in payments) {
      var a = {
        "MAIN_TYPE": element.mainType,
        "SUB_TYPE": element.subType,
        "SUB_TYPE_DESC": element.subTypeDesc.toString(),
        "YEAR_ID": element.yearId,
        "CHK_DATE": element.chkDate.toString(),
        "CHK_NO": element.chkNo,
        "CHK_AMT": element.chkAmt.toString(),
        "DUE": element.due.toString(),
        "REASON_ID": element.reasonId,
        "PAY_NO": element.payNo,
        "SEQ": element.seq,
        "CHECKED": element.isChecked ? "1" : null
      };
      data.add(jsonEncode(a).toString());
    }
    final response = await payRepository.issuanceOfUnifiedPaymentCodeService(data);
    return response;
  }

  void notifyMe() {
    notifyListeners();
  }
}