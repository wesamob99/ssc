// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../utilities/util.dart';

class UpdateMobileNumberScreen extends StatefulWidget {
  const UpdateMobileNumberScreen({Key key}) : super(key: key);

  @override
  State<UpdateMobileNumberScreen> createState() => _UpdateMobileNumberScreenState();
}

class _UpdateMobileNumberScreenState extends State<UpdateMobileNumberScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(translate('mobileNumber', context), style: const TextStyle(fontSize: 14),),
        leading: leadingBackIcon(context),
      ),
      body: Container(),
    );
  }
}
