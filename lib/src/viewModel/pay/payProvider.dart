// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';

import '../../../models/home/payOffFinancialInformations.dart';
import '../../model/pay/payRepository.dart';

class PayProvider extends ChangeNotifier {

  PayRepository payRepository = PayRepository();

  Future issuanceOfUnifiedPaymentCode(List<SubPayCur> payments) async{

    List<String> data;
    for (var element in payments) {
      data.add(
          {
            "MAIN_TYPE": element.mainType,
            "SUB_TYPE": element.subType,
            "SUB_TYPE_DESC": element.subTypeDesc,
            "YEAR_ID": element.yearId,
            "CHK_DATE": element.chkDate,
            "CHK_NO": element.chkNo,
            "CHK_AMT": element.chkAmt,
            "DUE": element.due,
            "REASON_ID": element.reasonId,
            "PAY_NO": element.payNo,
            "SEQ": element.seq,
            "CHECKED": element.isChecked ? "1" : ""
          }.toString()
      );
    }
    final response = await payRepository.issuanceOfUnifiedPaymentCodeService(data);
    return response;
  }

  void notifyMe() {
    notifyListeners();
  }
}