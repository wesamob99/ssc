// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssc/src/viewModel/utilities/theme/themeProvider.dart';
import 'package:ssc/utilities/hexColor.dart';

import '../../../../infrastructure/userConfig.dart';
import '../../../../utilities/theme/themes.dart';
import '../../../../utilities/util.dart';
import '../../../viewModel/accountSettings/accountSettingsProvider.dart';
import '../../splash/splashScreen.dart';

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
                            child: buildTextFormField(context, themeNotifier, accountSettingsProvider.mobileNumberController, '', (val){
                              accountSettingsProvider.notifyMe();
                            }),
                          ),
                          Text(
                            translate('mobileUpdateDesc', context),
                            style: TextStyle(
                              color: HexColor('#003C97'),
                              fontSize: 14
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: height(0.25, context)),
                        child: textButton(context, themeNotifier, 'update', (Provider.of<AccountSettingsProvider>(context).mobileNumberController.text.length != 9 ||
                            Provider.of<AccountSettingsProvider>(context).mobileNumberController.text == widget.mobileNumber)
                            ? HexColor('#DADADA')
                            : getPrimaryColor(context, themeNotifier),
                            (Provider.of<AccountSettingsProvider>(context).mobileNumberController.text.length == 9 &&
                                Provider.of<AccountSettingsProvider>(context).mobileNumberController.text != widget.mobileNumber)
                                ? HexColor('#ffffff') : HexColor('#363636'), () async {
                          if(accountSettingsProvider.mobileNumberController.text.length == 9 &&
                              accountSettingsProvider.mobileNumberController.text != widget.mobileNumber){
                            accountSettingsProvider.isLoading = true;
                            accountSettingsProvider.notifyMe();
                            String message = '';
                            try{
                              accountSettingsProvider.updateUserInfo(2, accountSettingsProvider.mobileNumberController.text).whenComplete((){}).then((value){
                                if(value["PO_STATUS"] == 0){
                                  showMyDialog(context, 'mobileNumberUpdatedSuccessfully', message, 'ok', themeNotifier, titleColor: '#2D452E', icon: 'assets/icons/profileIcons/mobileNumberUpdated.svg').then((value) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (context) => const SplashScreen()),
                                            (route) => false
                                    );
                                  });
                                }else{
                                  message = UserConfig.instance.checkLanguage()
                                      ? value["PO_STATUS_DESC_EN"] : value["PO_STATUS_DESC_AR"];
                                  showMyDialog(context, 'updateMobileNumberFailed', message, 'retryAgain', themeNotifier);
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
            )
          ],
        ),
      ),
    );
  }
}
