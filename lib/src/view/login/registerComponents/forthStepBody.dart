import 'package:flutter/material.dart';
import 'package:ssc/src/view/login/registerScreen.dart';

class ForthStepBody extends StatefulWidget {
  const ForthStepBody({Key key}) : super(key: key);

  @override
  State<ForthStepBody> createState() => _ForthStepBodyState();
}

class _ForthStepBodyState extends State<ForthStepBody> {
  @override
  Widget build(BuildContext context) {
    return RegisterScreen(
      stepNumber: 4,
      body: Container(
        color: Colors.pinkAccent,
      ),
    );
  }
}
