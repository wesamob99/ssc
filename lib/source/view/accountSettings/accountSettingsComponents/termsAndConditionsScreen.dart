// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../../../utilities/util.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({Key key}) : super(key: key);

  @override
  State<TermsAndConditionsScreen> createState() => _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(getTranslated('termsAndConditions', context), style: const TextStyle(fontSize: 14),),
        leading: leadingBackIcon(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(top: 25.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildExpandableWidget(context, 'agreeToTheTermsAndConditions', 'loremIpsum'),
              const SizedBox(height: 15.0),
              buildExpandableWidget(context, 'refundAndReturnPolicy', 'loremIpsum'),
              const SizedBox(height: 15.0),
              buildExpandableWidget(context, 'protectYourAccountAndIdentity', 'loremIpsum'),
            ],
          ),
        ),
      ),
    );
  }
}
