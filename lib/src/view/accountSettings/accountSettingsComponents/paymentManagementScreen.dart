// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../utilities/util.dart';

class PaymentManagementScreen extends StatefulWidget {
  const PaymentManagementScreen({Key key}) : super(key: key);

  @override
  State<PaymentManagementScreen> createState() => _PaymentManagementScreenState();
}

class _PaymentManagementScreenState extends State<PaymentManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(translate('paymentManagement', context), style: const TextStyle(fontSize: 14),),
        leading: leadingBackIcon(context),
      ),
      body: Container(),
    );
  }
}
