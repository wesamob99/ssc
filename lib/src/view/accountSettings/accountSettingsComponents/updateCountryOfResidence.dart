// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../utilities/util.dart';

class UpdateCountryOfResidence extends StatefulWidget {
  const UpdateCountryOfResidence({Key key}) : super(key: key);

  @override
  State<UpdateCountryOfResidence> createState() => _UpdateCountryOfResidenceState();
}

class _UpdateCountryOfResidenceState extends State<UpdateCountryOfResidence> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(translate('accountSettings', context), style: const TextStyle(fontSize: 14),),
        leading: leadingBackIcon(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              
            ],
          ),
        ),
      ),
    );
  }
}
