import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expandable_widget/flutter_expandable_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssc/source/view/splash/splashScreen.dart';
import 'package:ssc/source/viewModel/accountSettings/accountSettingsProvider.dart';
import 'package:ssc/source/viewModel/utilities/theme/themeProvider.dart';
import 'package:ssc/utilities/theme/themes.dart';
import '../infrastructure/userConfig.dart';
import '../source/view/pay/payScreen.dart';
import '../source/viewModel/home/homeProvider.dart';
import '../source/viewModel/login/loginProvider.dart';
import '../source/viewModel/services/servicesProvider.dart';
import '../source/viewModel/utilities/language/globalAppProvider.dart';
import 'hexColor.dart';
import 'language/appLocalizations.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

String getExtension(String url) {
  String reversed = url.split('').toList().reversed.join();
  String extension = reversed.substring(0, reversed.indexOf('.'));
  return extension.split('').toList().reversed.join();
}

double width(double value, BuildContext context) {
  return MediaQuery.of(context).size.width * value;
}

double height(double value, BuildContext context) {
  return MediaQuery.of(context).size.height * value;
}

navigator(BuildContext context, Widget screen) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => screen),
      ModalRoute.withName(''));
}

navigatorWithBack(BuildContext context, Widget screen) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => screen));
}

getTranslated(String key, BuildContext context) {
  return AppLocalizations.of(context)?.translate(key) ?? key;
}

bool isHTML(String text) {
  return text.contains('!DOCTYPE html');
}

bool isTablet(context){
  return width(1, context) > 600;
}

bool isScreenHasSmallWidth(context){
  return width(1, context) < 400;
}

bool isScreenHasSmallHeight(context){
  return height(1, context) < 700;
}

mobileNumberValidate(String number){
  if(number != '' && number[0] == '7' && number.length == 9){
    return (number.substring(0, 2) == "78" || number.substring(0, 2) == "77" || number.substring(0, 2) == "79");
  }else if(number != '' && number[0] == '0' && number.length == 10){
    return (number.substring(0, 3) == "078" || number.substring(0, 3) == "077" || number.substring(0, 3) == "079");
  } else{
    return false;
  }
}

bool checkTextLanguage(String text) {
  List<String> items = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N'
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];
  bool found = false;
  for (var element in items) {
    if (text.contains(element)) {
      found = true;
    }
  }
  return found;
}

String emailValidation(String value, BuildContext context) {
  return (value.isEmpty)
      ? AppLocalizations.of(context)?.translate('empty_email')
      : (!isEmail(value))
      ? AppLocalizations.of(context)?.translate('invalid_email')
      : null;
}

String passwordValidation(String value, BuildContext context) {
  return (value.isEmpty)
      ? AppLocalizations.of(context)?.translate('Cant_leave_pass_empty')
      : (!isValidPassword(value))
      ? AppLocalizations.of(context)?.translate('invalid_password')
      : null;
}

bool isStringIsEmptyOrNull(String value) {
  return value.isEmpty ? true : false;
}

String textValidation(String value, BuildContext context) {
  return (value.isEmpty)
      ? AppLocalizations.of(context)?.translate('text_empty')
      : null;
}

String progressValidation(String value, BuildContext context) {
  String progressValid = int.parse(value) < 0
      ? getTranslated('progressLessThan0', context)
      : int.parse(value) > 100
      ? getTranslated('progressGreaterThan100', context)
      : null;

  return progressValid;
}

bool isEmail(String email) {
  bool emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9\-]+\.[a-zA-Z]+")
      .hasMatch(email);
  return emailValid;
}

bool isValidPassword(String password) {
  bool passValid =
  RegExp(r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$")
      .hasMatch(password);
  return passValid;
}

String joinPaths(String path1, String path2) {
  if (path2.startsWith('/')) {
    path2 = path2.substring(1);
    if (!path1.endsWith('/')) {
      path1 = '$path1/';
    }
  }
  return path.join(path1, path2);
}

String getCurrentTimeInMilliSeconds() {
  return DateTime.now().millisecondsSinceEpoch.toString();
}

bool isProbablyArabic(String s) {
  for (int i = 0; i < s.length;) {
    int c = s.codeUnitAt(i);
    if (c >= 0x0600 && c <= 0x06E0) return true;
    i += c.toString().runes.length;
  }
  return false;
}

Widget somethingWrongWidget(BuildContext context, String title, String desc){
  ThemeNotifier themeNotifier = context.read<ThemeNotifier>();
  return Container(
    // height: height(0.25, context),
    alignment: Alignment.center,
    child: Card(
      color: getPrimaryColor(context, themeNotifier).withOpacity(0.4),
      elevation: 8.0,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width(0.05, context),
          vertical: height(0.035, context)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height(0.01, context),
            ),
            Center(
              child: SvgPicture.asset(
                'assets/icons/loginError.svg',
                height: width(0.18, context),
              ),
            ),
            SizedBox(
              height: height(0.01, context),
            ),
            Text(
              getTranslated(title, context),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: width(0.04, context)
              ),
            ),
            SizedBox(
              height: height(0.01, context),
            ),
            Text(
              getTranslated(desc, context),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: width(0.04, context)
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Future<void> showMyDialog(
    BuildContext context,
    String title,
    String body,
    String buttonText,
    ThemeNotifier themeNotifier,
    { bool withCancelButton = false,
    titleColor = '#ED3124',
    icon = 'assets/icons/loginError.svg',
    withPayButton = false,
    Widget extraWidgetBody = const SizedBox.shrink(),
    // ignore: avoid_init_to_null
    onPressed = null}
    ) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.white24,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: 7.0,
          sigmaY: 7.0,
        ),
        child: AlertDialog(
          elevation: 20,
          alignment: Alignment.center,
          actionsAlignment: MainAxisAlignment.center,
          iconPadding: EdgeInsets.symmetric(vertical: height(0.035, context)),
          contentPadding: EdgeInsets.symmetric(
            horizontal: width(0.07, context),
            vertical: height(0.025, context),
          ),
          actionsPadding: EdgeInsets.symmetric(
              vertical: height(0.03, context),
              horizontal: width(0.07, context)
          ).copyWith(top: 0),
          icon: SvgPicture.asset(icon, height: height(0.1, context),),
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: width(0.03, context)),
            child: Text(
              getTranslated(title, context),
              style: TextStyle(
                  color: HexColor(titleColor),
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          content: body != null && body != ''
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      body,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: themeNotifier.isLight() ? HexColor('#5F5F5F') : HexColor('ffffff'),
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  extraWidgetBody,
                ],
              )
          ) : const SizedBox.shrink(),
          actions: <Widget>[
            if(withPayButton)
            TextButton(
              onPressed: () async{
                try{
                  Provider.of<HomeProvider>(context, listen: false).getAmountToBePaid().whenComplete((){}).then((value){
                    if(value != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => PayScreen(payments: value.subPayCur[0]))
                      );
                    } else{
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const SplashScreen()
                        ), (route) => false,
                      );
                    }
                  });
                }catch(e){
                  if (kDebugMode) {
                    print(e.toString());
                  }
                }
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    getPrimaryColor(context, themeNotifier),
                  ),
                  foregroundColor:  MaterialStateProperty.all<Color>(
                      Colors.white
                  ),
                  fixedSize:  MaterialStateProperty.all<Size>(
                    Size(width(1, context), height(0.05, context)),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                      )
                  )
              ),
              child: Text(getTranslated('payNow', context)),
            ),
            SizedBox(height: withPayButton ? 10.0 : 0.0),
            TextButton(
              onPressed: onPressed ?? () async {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    withPayButton ? Colors.transparent : themeNotifier.isLight()
                        ? primaryColor : HexColor('#445740'),
                  ),
                  foregroundColor:  MaterialStateProperty.all<Color>(
                     withPayButton ? HexColor('#363636') : Colors.white
                  ),
                  fixedSize:  MaterialStateProperty.all<Size>(
                    Size(width(1, context), height(0.05, context)),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                      )
                  )
              ),
              child: Text(getTranslated(buttonText, context)),
            ),
            if(withCancelButton)
            const SizedBox(height: 5.0,),
            if(withCancelButton)
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      HexColor('#DADADA')
                  ),
                  foregroundColor:  MaterialStateProperty.all<Color>(
                      HexColor('#363636')
                  ),
                  fixedSize:  MaterialStateProperty.all<Size>(
                    Size(width(1, context), height(0.05, context)),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                      )
                  )
              ),
              child: Text(getTranslated('cancel', context)),
            ),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
      );
    },
  );
}

animatedLoader(context){
  return Material(
    elevation: 0.0,
    borderRadius: BorderRadius.circular(25.0),
    color: Colors.transparent,
    child: loadingIndicator(context)
  );
} //ballTrianglePath

SizedBox textButton(context, ThemeNotifier themeNotifier, String textKey, Color buttonColor, Color textColor, onPressed,
    {double verticalPadding  = 16.0, String borderColor = '#ffffff'}){
  return SizedBox(
    width: width(0.7, context),
    child: TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            buttonColor
          ),
          foregroundColor: MaterialStateProperty.all<Color>(
              Colors.white
          ),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: verticalPadding == 16.0 ? isTablet(context) ? 24 : 16.0 : verticalPadding)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                    color: HexColor(borderColor),
                    width: 1
                )
            ),
          )
      ),
      child: Text(
        getTranslated(textKey, context),
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w300
        ),
      ),
    ),
  );
}

SizedBox textButtonWithIcon(context, ThemeNotifier themeNotifier, String textKey, Color buttonColor, Color textColor, onPressed,
    {double verticalPadding  = 12.0, String borderColor = '#ffffff', var icon = Icons.add, String iconColor = '#2D452E'}){
  return SizedBox(
    width: width(0.7, context),
    child: TextButton.icon(
      onPressed: onPressed,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              buttonColor
          ),
          foregroundColor: MaterialStateProperty.all<Color>(
              Colors.white
          ),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: verticalPadding)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                    color: HexColor(borderColor),
                    width: 1
                )
            ),
          )
      ),
      label: Text(
        getTranslated(textKey, context),
        style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w300
        ),
      ),
      icon: icon is IconData
      ? Icon(
        icon,
        color: HexColor(iconColor),
      ) : SvgPicture.asset(icon),
    ),
  );
}

buildNoteField(context, note){
  return Container(
      width: width(1, context),
      decoration: BoxDecoration(
          color: HexColor('#FFF2CF'),
          borderRadius: BorderRadius.circular(8.0)
      ),
      child: Row(
        children: [
          Container(
            width: 10.0,
            height: 50,
            decoration: BoxDecoration(
                color: HexColor('#FFCA3A'),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(UserConfig.instance.isLanguageEnglish() ? 0.0 : 8.0),
                  bottomRight: Radius.circular(UserConfig.instance.isLanguageEnglish() ? 0.0 : 8.0),
                  topLeft: Radius.circular(UserConfig.instance.isLanguageEnglish() ? 8.0 : 0.0),
                  bottomLeft: Radius.circular(UserConfig.instance.isLanguageEnglish() ? 8.0 : 0.0),
                )
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            width: width(0.9, context),
            child: Text(
              getTranslated(note, context),
              style: TextStyle(
                  color: HexColor('##B48100'),
                  fontSize: 12
              ),
            ),
          ),
        ],
      )
  );
}

Widget buildFieldTitle(context, title, {required = true, filled = false}){
  ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
  return Row(
    children: [
      SizedBox(
        width: width(0.85, context),
        child: Text(
          getTranslated(title, context),
          style: TextStyle(
            color: themeNotifier.isLight() ? HexColor('#363636') : HexColor('#ffffff'),
            fontSize: isTablet(context) ? 20 : 14
          ),
        ),
      ),
      if(required)
      Text(
        ' *',
        style: TextStyle(
          color: filled
            ? themeNotifier.isLight() ? HexColor('#445740') : HexColor('#6f846b')
            : themeNotifier.isLight() ? HexColor('#FF1818') : HexColor('ffffff'),
        ),
      ),
    ],
  );
}

Container buildTextFormField(context, ThemeNotifier themeNotifier, TextEditingController controller,
    String hintText, onChanged, {isPassword = false,
      inputType = TextInputType.text, enabled = true, flag = 0, minLines = 1}){
  LoginProvider loginProvider = Provider.of<LoginProvider>(context, listen: false);
  AccountSettingsProvider accountSettingsProvider = Provider.of<AccountSettingsProvider>(context, listen: false);
  return Container(
    decoration: BoxDecoration(
      color: enabled ? Colors.transparent : const Color.fromRGBO(232, 232, 232, 0.8),
      borderRadius: BorderRadius.circular(8),
    ),
    child: TextFormField(
      minLines: minLines,
      maxLines: minLines,
      controller: controller,
      keyboardType: inputType,
      inputFormatters: (inputType == TextInputType.number) ? [FilteringTextInputFormatter.allow(RegExp('[0-9]'))] : [],
      obscureText: isPassword && ((Provider.of<LoginProvider>(context).resetObscurePassword && flag == 1) || (Provider.of<LoginProvider>(context).registerObscurePassword && flag == 2) || (Provider.of<AccountSettingsProvider>(context).updatePasswordIsObscure && flag == 3)) ,
      readOnly: !enabled,
      style: TextStyle(
        fontSize: isTablet(context) ? 20 : 13,
        color: enabled
            ? themeNotifier.isLight() ? HexColor('#363636') : Colors.white
            : themeNotifier.isLight() ? HexColor('#6B6B6B') : HexColor('#999999')
      ),
      cursorColor: themeNotifier.isLight()
          ? getPrimaryColor(context, themeNotifier)
          : Colors.white,
      cursorWidth: 1,
      decoration: InputDecoration(
          suffixIcon: isPassword
          ? InkWell(
            onTap: (){
              if(flag == 1) {
                loginProvider.resetObscurePassword = !loginProvider.resetObscurePassword;
              } else if(flag == 2) {
                loginProvider.registerObscurePassword = !loginProvider.registerObscurePassword;
              } else if(flag == 3) {
                accountSettingsProvider.updatePasswordIsObscure = !accountSettingsProvider.updatePasswordIsObscure;
              }
              loginProvider.notifyMe();
              accountSettingsProvider.notifyMe();
            },
            child: Icon(
              (Provider.of<LoginProvider>(context).resetObscurePassword && flag == 1) || (Provider.of<LoginProvider>(context).registerObscurePassword && flag == 2 || (Provider.of<AccountSettingsProvider>(context).updatePasswordIsObscure && flag == 3))
                  ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
              size: 20,
              color: themeNotifier.isLight()
                  ? getPrimaryColor(context, themeNotifier)
                  : Colors.white,
            ),
          )
          : const SizedBox.shrink(),
          hintText: hintText == '' ? '' : hintText.substring(0, 3) == 'val' ? hintText.substring(3) : getTranslated('ex', context) + hintText,
          hintStyle: TextStyle(
            color: getGrey2Color(context).withOpacity(
              themeNotifier.isLight() ? 1 : 0.7,
            ),
            fontSize:  isTablet(context) ? 19 : 14,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: isTablet(context) ? 20 : minLines != 1 ? 5 : 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: themeNotifier.isLight()
                  ? getPrimaryColor(context, themeNotifier)
                  : Colors.white,
              width: 0.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: themeNotifier.isLight()
                  ? getPrimaryColor(context, themeNotifier)
                  : Colors.white,
              width: 0.8,
            ),
          )
      ),
      onChanged: onChanged,
    ),
  );
}


loginSuggestionsModalBottomSheet(context, themeNotifier, supportState, authenticate){
  return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0))
      ),
      context: context,
      barrierColor: Colors.white24,
      builder: (context) {
        return BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: 6.0,
            sigmaY: 6.0,
          ),
          child: Material(
            elevation: 100,
            borderRadius: BorderRadius.circular(25.0),
            color: Colors.white,
            shadowColor: Colors.black,
            child: SizedBox(
              height: height(supportState == SupportState.supported ? 0.5 : isScreenHasSmallHeight(context) ? 0.45 : 0.42, context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: height(0.02, context),
                      horizontal: width(0.07, context),
                    ).copyWith(bottom: height(0.01, context)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getTranslated('defineAnotherWayToEnter', context),
                          style: TextStyle(
                            color: HexColor('#363636'),
                            fontWeight: FontWeight.bold,
                            fontSize: isTablet(context) ? 20 : 14
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.of(context).pop();
                          },
                          child: SvgPicture.asset('assets/icons/close.svg'),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: HexColor('#DADADA'),
                    thickness: 1,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: height(0.02, context),
                        horizontal: width(0.07, context),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            getTranslated('defineAnotherWayToEnterDesc', context),
                            style: TextStyle(
                                color: HexColor('#363636'),
                                height: 1.5
                            ),
                          ),
                          SizedBox(height: height(0.04, context),),
                          supportState == SupportState.supported
                          ? TextButton(
                            onPressed: authenticate,
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    HexColor('#E7EFE5')
                                ),
                                fixedSize:  MaterialStateProperty.all<Size>(
                                  Size(width(1, context), height(0.07, context)),
                                ),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
                                )
                            ),
                            child: Text(
                              getTranslated('fingerprintOrFace', context),
                              style: TextStyle(
                                  color: HexColor('#363636'),
                                  fontWeight: FontWeight.w200
                              ),
                            ),
                          )
                          : const SizedBox.shrink(),
                          SizedBox(height: height(supportState == SupportState.supported ? 0.015 : 0.0, context),),
                          TextButton(
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    HexColor('#E7EFE5')
                                ),
                                fixedSize:  MaterialStateProperty.all<Size>(
                                  Size(width(1, context), height(0.07, context)),
                                ),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
                                )
                            ),
                            child: Text(
                              getTranslated('passcode', context),
                              style: TextStyle(
                                color: HexColor('#363636'),
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ),
                          SizedBox(height: height(0.015, context),),
                          TextButton(
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    HexColor('#ffffff')
                                ),
                                fixedSize:  MaterialStateProperty.all<Size>(
                                  Size(width(1, context), height(0.07, context)),
                                ),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
                                )
                            ),
                            child: Text(
                              getTranslated('skip', context),
                              style: TextStyle(
                                color: HexColor('#363636'),
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ),
                        ],
                      )
                  )
                ],
              ),
            ),
          ),
        );
      }
  );
}

rateServiceBottomSheet(context, themeNotifier, ServicesProvider servicesProvider){
  return showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0))
      ),
      context: context,
      barrierColor: Colors.black26,
      builder: (context) {
        return GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: 2.0,
              sigmaY: 2.0,
            ),
            child: Material(
              elevation: 100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
              color: Colors.white,
              shadowColor: Colors.black,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0).copyWith(top: 15.0),
                height: isScreenHasSmallHeight(context) ? height(0.63, context) : height(0.58, context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 45,
                          height: 6,
                          decoration: BoxDecoration(
                              color: HexColor('#000000'),
                              borderRadius: const BorderRadius.all(Radius.circular(25.0))),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height(0.015, context),
                    ),
                    Text(
                      getTranslated('serviceEvaluation', context),
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: height(0.023, context),
                      ),
                    ),
                    SizedBox(
                      height: height(0.023, context),
                    ),
                    Text(
                      getTranslated('howEasyToApply', context),
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: height(0.018, context),
                      ),
                    ),
                    SizedBox(
                      height: height(0.013, context),
                    ),
                    Text(
                      getTranslated('howEasyToApplyDesc', context),
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12.0,
                          color: HexColor('#979797')
                      ),
                    ),
                    SizedBox(
                      height: height(0.02, context),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: width(1, context),
                      height: width(0.14, context),
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 5,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index){
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  customBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  onTap: (){
                                    servicesProvider.selectedServiceRate = index + 1;
                                    servicesProvider.notifyMe();
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: width(isTablet(context) ? 0.1 : 0.13, context),
                                    height: width(isTablet(context) ? 0.1 : 0.13, context),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Provider.of<ServicesProvider>(context).selectedServiceRate == index + 1 ? HexColor('#2D452E') : HexColor('#A6A6A6'),
                                      borderRadius: BorderRadius.circular(500.0),
                                    ),
                                    child: Text(
                                      '${5 - index}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: width(0.02, context))
                              ],
                            );
                          }
                      ),
                    ),
                    SizedBox(
                      height: height(0.025, context),
                    ),
                    Text(
                      getTranslated('shareYourOpinion', context),
                      style: TextStyle(
                        fontSize: height(0.018, context),
                      ),
                    ),
                    SizedBox(
                      height: height(0.012, context),
                    ),
                    buildTextFormField(context, themeNotifier, TextEditingController(), '', (value){}, minLines: 5),
                    SizedBox(
                      height: height(0.03, context),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width(0.1, context)),
                      child: textButton(context, themeNotifier, 'done',
                        Provider.of<ServicesProvider>(context).selectedServiceRate != -1 ? primaryColor : HexColor('#DADADA'),
                        Provider.of<ServicesProvider>(context).selectedServiceRate != -1 ?  Colors.white : HexColor('#363636'), (){
                        if(servicesProvider.selectedServiceRate != -1){
                          servicesProvider.notifyMe();
                          while(Navigator.canPop(context)){ // Navigator.canPop return true if can pop
                            Navigator.pop(context);
                          }
                        }
                      }, verticalPadding: height(0.023, context)),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
  );
}

loadingIndicator(BuildContext context){
  return SizedBox(
    width: width(isTablet(context) ? 0.2 : 0.4, context),
    height: width(isTablet(context) ? 0.2 : 0.4, context),
    child: LoadingIndicator(
      indicatorType: Indicator.ballBeat, /// Required, The loading type of the widget
      colors: [
        HexColor('#6f846b'),
        HexColor('#c99639')
      ],
      backgroundColor: Colors.transparent,
    ),
  );
}

leadingBackIcon(context){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: (){
        Navigator.of(context).pop();
      },
      child: Transform.rotate(
        angle: UserConfig.instance.isLanguageEnglish()
            ? -math.pi / 1.0 : 0,
        child: SvgPicture.asset(
            'assets/icons/backWhite.svg'
        ),
      ),
    ),
  );
}

buildExpandableWidget(context, String title, dynamic child, {bool needTranslate = true, bool isChildTypeText = true}){
  return ExpandableWidget(
    titlePadding: const EdgeInsets.all(10.0),
    padding: const EdgeInsets.all(0.0),
    title: Expanded(
      child: Text(
        needTranslate ? getTranslated(title, context) : title,
        style: TextStyle(
            color: HexColor('#363636')
        ),
      ),
    ),
    decoration: BoxDecoration(
        color: const Color.fromRGBO(45, 69, 46, 0.06),
        borderRadius: BorderRadius.circular(8.0)
    ),
    childrenDecoration: const BoxDecoration(
      color: Color.fromRGBO(250, 250, 250, 1.0),
    ),
    childrenPadding: const EdgeInsets.only(top: 10),
    children: [
      isChildTypeText
      ? Text(
        getTranslated(child, context),
        style: TextStyle(
            color: HexColor('#363636')
        ),
      ) : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: child,
      ),
    ],
  );
}

updateLanguageWidget(BuildContext context){
  bool isEnglish = UserConfig.instance.isLanguageEnglish();
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
  return InkWell(
    onTap: () async{
      Provider.of<GlobalAppProvider>(context, listen: false).changeLanguage(Locale(isEnglish ? "ar" : "en"));
      Provider.of<GlobalAppProvider>(context, listen: false).notifyMe();
      prefs.then((value) {
        value.setString('language_code', isEnglish ? 'ar' : 'en');
      });
    },
    child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        alignment: Alignment.topRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              UserConfig.instance.isLanguageEnglish() ? 'عربي' : 'English',
              style: TextStyle(
                color: themeNotifier.isLight()
                    ? primaryColor
                    : Colors.white,
              ),
            ),
            const SizedBox(width: 5.0),
            SvgPicture.asset(
              'assets/icons/global.svg',
              color: themeNotifier.isLight()
                  ? HexColor('#5D6470')
                  : Colors.white,
            ),
          ],
        )
    ),
  );
}

/// TODO: download the file correctly
// Function to download a PDF file from the server
Future<void> downloadPDF(Response response, String fileName) async {
  try {
    // Get the directory to store the file
    var documentsDirectory = await getApplicationDocumentsDirectory();

    // Create the file on the device
    File pdfFile = File('${documentsDirectory.path}/$fileName.pdf');
    pdfFile = await pdfFile.create();

    // Write file content to the file
    await pdfFile.writeAsBytes(utf8.encode(response.data));

    // Open the file on the device
    OpenFilex.open(pdfFile.path);
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

// Future<void> saveFile(String fileName, Response response) async {
//   var file = File('');
//
//   // Platform.isIOS comes from dart:io
//   if (Platform.isIOS) {
//     final dir = await getApplicationDocumentsDirectory();
//     file = File('${dir.path}/$fileName');
//   }
//
//   if (Platform.isAndroid) {
//     var status = await Permission.storage.status;
//     if (status != PermissionStatus.granted) {
//       status = await Permission.storage.request();
//     }
//     if (status.isGranted) {
//       const downloadsFolderPath = '/storage/emulated/0/Download/';
//       Directory dir = Directory(downloadsFolderPath);
//       file = File('${dir.path}/$fileName');
//     }
//   }
//
//   final byteData = response.bodyBytes;
//   try {
//     await file.writeAsBytes(byteData.buffer
//         .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
//   } on FileSystemException catch (err) {
//     // handle error
//   }
// }

enum SupportState{
  unknown,
  supported,
  unsupported
}