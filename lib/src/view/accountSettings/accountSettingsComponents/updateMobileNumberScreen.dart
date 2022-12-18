// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssc/src/viewModel/utilities/theme/themeProvider.dart';
import 'package:ssc/utilities/hexColor.dart';

import '../../../../utilities/theme/themes.dart';
import '../../../../utilities/util.dart';
import '../../../viewModel/accountSettings/accountSettingsProvider.dart';

class UpdateMobileNumberScreen extends StatefulWidget {
  const UpdateMobileNumberScreen({Key key}) : super(key: key);

  @override
  State<UpdateMobileNumberScreen> createState() => _UpdateMobileNumberScreenState();
}

class _UpdateMobileNumberScreenState extends State<UpdateMobileNumberScreen> {

  AccountSettingsProvider accountSettingsProvider;
  ThemeNotifier themeNotifier;

  @override
  void initState() {
    accountSettingsProvider = Provider.of<AccountSettingsProvider>(context, listen: false);
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(translate('updateMobileNumber', context), style: const TextStyle(fontSize: 14),),
        leading: leadingBackIcon(context),
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0).copyWith(top: 25.0),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: height(1, context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          buildFieldTitle(context, 'mobileNumber', required: false),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
                            child: buildTextFormField(context, themeNotifier, TextEditingController(), '', (val){}),
                          ),
                          Text(
                            translate('mobileUpdateDesc', context),
                            style: TextStyle(
                                color: HexColor('#003C97')
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: height(0.25, context)),
                        child: textButton(context, themeNotifier, 'update', !Provider.of<AccountSettingsProvider>(context).updatePasswordEnabled
                            ? HexColor('#DADADA')
                            : getPrimaryColor(context, themeNotifier),
                            Provider.of<AccountSettingsProvider>(context).updatePasswordEnabled
                                ? HexColor('#ffffff') : HexColor('#363636'), () async {}
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
