import 'package:flutter/material.dart';

import '../../../utilities/util.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({Key key}) : super(key: key);

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(translate('paymentMethods', context)),
        leading: leadingBackIcon(context),
      ),
      body: Container(),
    );
  }
}
