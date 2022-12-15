// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssc/src/viewModel/accountSettings/accountSettingsProvider.dart';

import '../../../../infrastructure/userConfig.dart';
import '../../../../utilities/hexColor.dart';
import '../../../../utilities/theme/themes.dart';
import '../../../../utilities/util.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';
import '../../splash/splashScreen.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({Key key}) : super(key: key);

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {

  List<String> validators = ["pwValidator1", "pwValidator2", "pwValidator3", "pwValidator4", "pwValidator5", "pwValidator6"];
  List<bool> validatorsCheck = [false, false, false, false, false, false];
  AccountSettingsProvider accountSettingsProvider;

  @override
  void initState() {
    accountSettingsProvider = Provider.of<AccountSettingsProvider>(context, listen: false);
    accountSettingsProvider.currentPasswordController.text = "";
    accountSettingsProvider.newPasswordController.text = "";
    accountSettingsProvider.confirmNewPasswordController.text = "";
    accountSettingsProvider.isLoading = false;
    accountSettingsProvider.updatePasswordIsObscure = false;
    accountSettingsProvider.updatePasswordEnabled = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(translate('updatePassword', context), style: const TextStyle(fontSize: 14),),
        leading: leadingBackIcon(context),
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0).copyWith(top: 25),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildFieldTitle(context, 'currentPassword', required: false),
                    SizedBox(height: height(0.015, context),),
                    buildTextFormField(context, themeNotifier, accountSettingsProvider.currentPasswordController, '', (val){
                      passwordValidator(val, accountSettingsProvider);
                    }, isPassword: true, flag: 3),
                    SizedBox(height: height(0.02, context),),
                    buildFieldTitle(context, 'newPassword', required: false),
                    SizedBox(height: height(0.015, context),),
                    buildTextFormField(context, themeNotifier, accountSettingsProvider.newPasswordController, '', (val){
                      passwordValidator(val, accountSettingsProvider);
                    }, isPassword: true, flag: 3),
                    SizedBox(height: height(0.02, context),),
                    buildFieldTitle(context, 'confirmNewPassword', required: false),
                    SizedBox(height: height(0.015, context),),
                    buildTextFormField(context, themeNotifier, accountSettingsProvider.confirmNewPasswordController, '', (val){
                      passwordValidator(val, accountSettingsProvider);
                    }, isPassword: true, flag: 3),
                    SizedBox(height: height(0.015, context),),
                    SizedBox(
                      height: height(0.25, context),
                      child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: width(0.3, context),
                              childAspectRatio: 100 / (isTablet(context) ? height(0.02, context) : height(0.04, context)),
                              crossAxisSpacing: 6,
                              mainAxisSpacing: 12
                          ),
                          itemCount: validators.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: validatorsCheck[index]
                                        ? HexColor('#946800') : HexColor('#EDEDED'),
                                    borderRadius: BorderRadius.circular(8.0)
                                ),
                                child: Text(
                                  translate(validators[index], context),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: validatorsCheck[index]
                                          ? HexColor('#FFFFFF') : HexColor('#595959'),
                                      fontSize: height(isTablet(context) ? 0.01 : 0.012, context)
                                  ),
                                )
                            );
                          }
                      ),
                    ),
                    textButton(context, themeNotifier, 'update', !Provider.of<AccountSettingsProvider>(context).updatePasswordEnabled
                        ? HexColor('#DADADA')
                        : getPrimaryColor(context, themeNotifier),
                        Provider.of<AccountSettingsProvider>(context).updatePasswordEnabled
                            ? HexColor('#ffffff') : HexColor('#363636'), () async {
                          if(accountSettingsProvider.updatePasswordEnabled){
                            accountSettingsProvider.isLoading = true;
                            accountSettingsProvider.notifyMe();
                            String message = '';
                            try{
                              await accountSettingsProvider.updatePassword(
                                  accountSettingsProvider.newPasswordController.text,
                                  accountSettingsProvider.currentPasswordController.text
                                ).whenComplete((){}).then((value){
                                if(value["PO_STATUS"] == 1){
                                  showMyDialog(context, 'updatePasswordSuccessfully', message, 'ok', themeNotifier, titleColor: '#2D452E').then((value) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (context) => const SplashScreen()),
                                            (route) => false
                                    );
                                  });
                                }else{
                                  message = UserConfig.instance.checkLanguage()
                                      ? value["PO_STATUS_DESC_EN"] : value["PO_STATUS_DESC_AR"];
                                  showMyDialog(context, 'updatePasswordFailed', message, 'retryAgain', themeNotifier);
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
                  ],
                ),
              ),
            ),
            if(accountSettingsProvider.isLoading)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: width(1, context),
              height: height(1, context),
              color: Colors.white70,
              child: Center(
                child: animatedLoader(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  passwordValidator(value, AccountSettingsProvider accountSettingsProvider){
    accountSettingsProvider.notifyMe();
    if(accountSettingsProvider.newPasswordController.text.length >= 8){ // At least 8 character
      setState(() {
        validatorsCheck[0] = true;
      });
    } else{
      setState(() {
        validatorsCheck[0] = false;
      });
    }
    if(accountSettingsProvider.newPasswordController.text.contains(RegExp("(?:[^a-z]*[a-z]){1}"))){ //Lowercase letter (a-z)
      setState(() {
        validatorsCheck[1] = true;
      });
    } else{
      setState(() {
        validatorsCheck[1] = false;
      });
    }
    if(accountSettingsProvider.newPasswordController.text.contains(RegExp("(?:[^A-Z]*[A-Z]){1}"))){ //Uppercase letter (A-Z)
      setState(() {
        validatorsCheck[2] = true;
      });
    } else{
      setState(() {
        validatorsCheck[2] = false;
      });
    }
    if(accountSettingsProvider.newPasswordController.text.contains(RegExp(r'[-+=!@#$%^&*(),.?":{}|<>]'))){ //Special character (*!&#^@)
      setState(() {
        validatorsCheck[3] = true;
      });
    } else{
      setState(() {
        validatorsCheck[3] = false;
      });
    }
    if(accountSettingsProvider.newPasswordController.text.contains(RegExp("(?:[0-9]){1}"))){ //Number (1-9)
      setState(() {
        validatorsCheck[4] = true;
      });
    } else{
      setState(() {
        validatorsCheck[4] = false;
      });
    }
    if(accountSettingsProvider.newPasswordController.text ==
        accountSettingsProvider.confirmNewPasswordController.text &&
        accountSettingsProvider.newPasswordController.text.isNotEmpty &&
        accountSettingsProvider.confirmNewPasswordController.text.isNotEmpty){ // Password is the same as the confirm password
      setState(() {
        validatorsCheck[5] = true;
      });
    } else{
      setState(() {
        validatorsCheck[5] = false;
      });
    }
    accountSettingsProvider.updatePasswordEnabled = !validatorsCheck.contains(false) && accountSettingsProvider.currentPasswordController.text.isNotEmpty;
    accountSettingsProvider.notifyMe();
  }

}
