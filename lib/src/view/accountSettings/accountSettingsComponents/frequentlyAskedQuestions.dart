// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../../../utilities/util.dart';

class FrequentlyAskedQuestions extends StatefulWidget {
  const FrequentlyAskedQuestions({Key key}) : super(key: key);

  @override
  State<FrequentlyAskedQuestions> createState() => _FrequentlyAskedQuestionsState();
}

class _FrequentlyAskedQuestionsState extends State<FrequentlyAskedQuestions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(translate('frequentlyAskedQuestions', context), style: const TextStyle(fontSize: 14),),
        leading: leadingBackIcon(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(top: 25.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildExpandableWidget(context, 'whatIsSocialSecurity', 'loremIpsum'),
              const SizedBox(height: 15.0),
              buildExpandableWidget(context, 'howCanIBenefitFromSocialSecurityServices', 'loremIpsum'),
              const SizedBox(height: 15.0),
              buildExpandableWidget(context, 'howDoIApplyToWorkOnSocialSecurity', 'loremIpsum'),
            ],
          ),
        ),
      ),
    );
  }
}


