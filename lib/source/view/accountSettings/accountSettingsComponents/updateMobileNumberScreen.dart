// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssc/source/viewModel/services/servicesProvider.dart';
import 'package:ssc/source/viewModel/utilities/theme/themeProvider.dart';
import 'package:ssc/utilities/hexColor.dart';

import '../../../../infrastructure/userConfig.dart';
import '../../../../utilities/theme/themes.dart';
import '../../../../utilities/util.dart';
import '../../../viewModel/accountSettings/accountSettingsProvider.dart';
import '../../login/registerComponents/OTPScreen.dart';

class UpdateMobileNumberScreen extends StatefulWidget {
  final String mobileNumber;
  const UpdateMobileNumberScreen({Key key, this.mobileNumber}) : super(key: key);

  @override
  State<UpdateMobileNumberScreen> createState() => _UpdateMobileNumberScreenState();
}

class _UpdateMobileNumberScreenState extends State<UpdateMobileNumberScreen> {

  AccountSettingsProvider accountSettingsProvider;
  ThemeNotifier themeNotifier;

  @override
  void initState() {
    accountSettingsProvider = Provider.of<AccountSettingsProvider>(context, listen: false);
    accountSettingsProvider.mobileNumberController.text = widget.mobileNumber;
    accountSettingsProvider.isLoading = false;
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildFieldTitle(context, 'mobileNumber', required: false),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
                            child: buildTextFormField(context, themeNotifier, accountSettingsProvider.mobileNumberController, '', (val){
                              accountSettingsProvider.notifyMe();
                            }),
                          ),
                          Text(
                            translate('mobileUpdateDesc', context),
                            style: TextStyle(
                              color: HexColor(themeNotifier.isLight() ? '#003C97' : '#00b0ff'),
                              fontSize: 14
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: height(0.25, context)),
                        child: textButton(context, themeNotifier, 'update', (!mobileNumberValidate(Provider.of<AccountSettingsProvider>(context).mobileNumberController.text) ||
                            Provider.of<AccountSettingsProvider>(context).mobileNumberController.text == widget.mobileNumber)
                            ? HexColor('#DADADA')
                            : getPrimaryColor(context, themeNotifier),
                            (mobileNumberValidate(Provider.of<AccountSettingsProvider>(context).mobileNumberController.text) &&
                                Provider.of<AccountSettingsProvider>(context).mobileNumberController.text != widget.mobileNumber)
                                ? HexColor('#ffffff') : HexColor('#363636'), () async {
                          if(mobileNumberValidate(Provider.of<AccountSettingsProvider>(context).mobileNumberController.text) &&
                              accountSettingsProvider.mobileNumberController.text != widget.mobileNumber){
                            accountSettingsProvider.isLoading = true;
                            accountSettingsProvider.notifyMe();
                            String errorMessage = '';
                            try{
                              await Provider.of<ServicesProvider>(context, listen: false).updateUserMobileNumberSendOTP(accountSettingsProvider.mobileNumberController.text)
                                  .whenComplete((){}).then((value){
                                if(value['PO_STATUS'] == '1'){
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => OTPScreen(
                                      contactTarget: accountSettingsProvider.mobileNumberController.text,
                                      type: 'phone',
                                      flag: 2,
                                    ))
                                  );
                                }else{
                                  errorMessage = UserConfig.instance.checkLanguage()
                                      ? value["PO_STATUS_DESC_EN"] : value["PO_STATUS_DESC_AR"];
                                  showMyDialog(context, 'updateMobileNumberFailed', errorMessage, 'retryAgain', themeNotifier);
                                }
                              });
                              accountSettingsProvider.isLoading = false;
                              accountSettingsProvider.notifyMe();
                            }catch(e){
                              accountSettingsProvider.isLoading = false;
                              accountSettingsProvider.notifyMe();
                              if (kDebugMode) {
                                print(e.toString());
                              }
                            }
                            }
                          }
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if(Provider.of<AccountSettingsProvider>(context).isLoading)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: width(1, context),
              height: height(1, context),
              color: themeNotifier.isLight() ? Colors.white70 : Colors.black45,
              child: Center(
                child: animatedLoader(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
