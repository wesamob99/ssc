import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_widget/flutter_expandable_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:ssc/src/view/splash/splashScreen.dart';
import 'package:ssc/src/viewModel/accountSettings/accountSettingsProvider.dart';
import 'package:ssc/src/viewModel/utilities/theme/themeProvider.dart';
import 'package:ssc/utilities/theme/themes.dart';
import '../infrastructure/userConfig.dart';
import '../src/view/pay/payScreen.dart';
import '../src/viewModel/home/homeProvider.dart';
import '../src/viewModel/login/loginProvider.dart';
import '../src/viewModel/services/servicesProvider.dart';
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

translate(String key, BuildContext context) {
  return AppLocalizations.of(context)?.translate(key) ?? "No Translate";
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
      ? translate('progressLessThan0', context)
      : int.parse(value) > 100
      ? translate('progressGreaterThan100', context)
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
              translate(title, context),
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
              translate(desc, context),
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
    {titleColor = '#ED3124',
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
              translate(title, context),
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
                          color: HexColor('#5F5F5F'),
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
              child: Text(translate('payNow', context)),
            ),
            SizedBox(height: withPayButton ? 10.0 : 0.0),
            TextButton(
              onPressed: onPressed ?? () async {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    withPayButton ? Colors.transparent : getPrimaryColor(context, themeNotifier),
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
              child: Text(translate(buttonText, context)),
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
    elevation: 10.0,
    borderRadius: BorderRadius.circular(25.0),
  child: Container(
      width: width(isTablet(context) ? 0.3 : 0.4, context),
      height: width(isTablet(context) ? 0.3 : 0.4, context),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(25.0)
      ),
      child: Image.asset(
        "assets/logo/loaderLogo.gif",
      ),
    ),
  );
}

SizedBox textButton(context, themeNotifier, text, buttonColor, textColor, onPressed,
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
      child: Text(
        translate(text, context),
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w300
        ),
      ),
    ),
  );
}


Widget buildFieldTitle(context, title, {required = true, filled = false}){
  return Row(
    children: [
      Text(
        translate(title, context),
        style: TextStyle(
          color: HexColor('#363636'),
          fontSize: isTablet(context) ? width(0.025, context) : width(0.032, context)
        ),
      ),
      if(required)
      Text(
        ' *',
        style: TextStyle(
          color: filled ? HexColor('#445740') : HexColor('#FF1818'),
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
      obscureText: isPassword && ((Provider.of<LoginProvider>(context).resetObscurePassword && flag == 1) || (Provider.of<LoginProvider>(context).registerObscurePassword && flag == 2) || (Provider.of<AccountSettingsProvider>(context).updatePasswordIsObscure && flag == 3)) ,
      readOnly: !enabled,
      style: TextStyle(
        fontSize: isTablet(context) ? 20 : 15,
        color: enabled ? HexColor('#363636') : HexColor('#6B6B6B')
      ),
      cursorColor: getPrimaryColor(context, themeNotifier),
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
          ) : const SizedBox.shrink(),
          hintText: hintText == '' ? '' : translate('ex', context) + hintText,
          hintStyle: TextStyle(
            color: getGrey2Color(context).withOpacity(
              themeNotifier.isLight() ? 1 : 0.5,
            ),
            fontSize:  isTablet(context) ? 19 : 14,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: isTablet(context) ? 20 : minLines != 1 ? 5 : 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: getPrimaryColor(context, themeNotifier),
              width: 0.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: getPrimaryColor(context, themeNotifier),
              width: 0.8,
            ),
          )
      ),
      onChanged: onChanged,
    ),
  );
}


modalBottomSheet(context, themeNotifier, supportState, authenticate){
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
                          translate('defineAnotherWayToEnter', context),
                          style: TextStyle(
                            color: HexColor('#363636'),
                            fontWeight: FontWeight.bold,
                            fontSize: width(0.04, context),
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
                            translate('defineAnotherWayToEnterDesc', context),
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
                              translate('fingerprintOrFace', context),
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
                              translate('passcode', context),
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
                              translate('skip', context),
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
                      translate('serviceEvaluation', context),
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: height(0.023, context),
                      ),
                    ),
                    SizedBox(
                      height: height(0.023, context),
                    ),
                    Text(
                      translate('howEasyToApply', context),
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: height(0.018, context),
                      ),
                    ),
                    SizedBox(
                      height: height(0.013, context),
                    ),
                    Text(
                      translate('howEasyToApplyDesc', context),
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
                      translate('shareYourOpinion', context),
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

loadingIndicator(context){
  return SizedBox(
    width: width(isTablet(context) ? 0.2 : 0.4, context),
    height: width(isTablet(context) ? 0.2 : 0.4, context),
    child: LoadingIndicator(
      indicatorType: Indicator.ballSpinFadeLoader, /// Required, The loading type of the widget
      colors: [
        HexColor('#445740'), HexColor('#946800').withOpacity(0.6)
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
        angle: UserConfig.instance.checkLanguage()
            ? -math.pi / 1.0 : 0,
        child: SvgPicture.asset(
            'assets/icons/backWhite.svg'
        ),
      ),
    ),
  );
}

buildExpandableWidget(context, String title, String child){
  return ExpandableWidget(
    titlePadding: const EdgeInsets.all(10.0),
    padding: const EdgeInsets.all(0.0),
    title: Expanded(
      child: Text(
        translate(title, context),
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
      Text(
        translate(child, context),
        style: TextStyle(
            color: HexColor('#363636')
        ),
      ),
    ],
  );
}

enum SupportState{
  unknown,
  supported,
  unsupported
}