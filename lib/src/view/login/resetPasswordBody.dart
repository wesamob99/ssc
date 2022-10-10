// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../infrastructure/userSecuredStorage.dart';
import '../../../utilities/util.dart';

class ResetPasswordBody extends StatefulWidget {
  const ResetPasswordBody({Key key}) : super(key: key);

  @override
  State<ResetPasswordBody> createState() => _ResetPasswordBodyState();
}

class _ResetPasswordBodyState extends State<ResetPasswordBody> {
  @override
  Widget build(BuildContext context) {
    UserSecuredStorage userSecuredStorage = UserSecuredStorage.instance;
    return Column(
      children: [
        Text(
          translate('identityVerify', context),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: width(0.04, context)
          ),
        ),
        SizedBox(height: height(0.04, context),),
        Column(
          children: [
            Text(
              translate('enterVerificationCode', context),
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: width(0.033, context)
              ),
            ),
            SizedBox(height: height(0.015, context),),
            Text(
              userSecuredStorage.mobileNumber,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: width(0.033, context),
              ),
            )
          ],
        )
      ],
    );
  }
}
