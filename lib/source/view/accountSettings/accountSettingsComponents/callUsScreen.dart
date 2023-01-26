// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/source/viewModel/utilities/theme/themeProvider.dart';

import '../../../../utilities/hexColor.dart';
import '../../../../utilities/util.dart';
import 'package:url_launcher/url_launcher.dart';


class CallUsScreen extends StatefulWidget {
  const CallUsScreen({Key key}) : super(key: key);

  @override
  State<CallUsScreen> createState() => _CallUsScreenState();
}

class _CallUsScreenState extends State<CallUsScreen> {

  ThemeNotifier themeNotifier;

  @override
  void initState() {
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    super.initState();
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
    )) {
      showMyDialog(context, 'failed', translate('unableToOpenTheLink', context) + '\n $url', 'ok', themeNotifier);
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'https',
      path: url(phoneNumber),
    );
    if(await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else{
      showMyDialog(context, 'failed', translate('unableToOpenWhatsApp', context) + '\n $phoneNumber', 'ok', themeNotifier);
    }
  }

  String url(String phone) {
    if (Platform.isAndroid) {
      // add the [https]
      return "wa.me/$phone/?text=Hello"; // new line
    } else {
      // add the [https]
      return "api.whatsapp.com/send?phone=$phone&text=Hello"; // new line
    }
  }

  Future<void> _sendEmail(String mail) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: mail,
    );
    if(await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else{
      showMyDialog(context, 'failed', translate('unableToOpenTheEmail', context) + '\n $mail', 'ok', themeNotifier);
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if(await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else{
      showMyDialog(context, 'failed', translate('unableToMakePhoneCall', context) + '\n $phoneNumber', 'ok', themeNotifier);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(translate('callUs', context), style: const TextStyle(fontSize: 14),),
        leading: leadingBackIcon(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: SizedBox(
            width: width(1, context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 18),
                SvgPicture.asset('assets/images/accountSettingsImages/callUsImage.svg'),
                const SizedBox(height: 30),
                SizedBox(
                  width: width(1, context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translate('needHelp', context),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: HexColor('#363636'),
                          fontSize: 18
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        translate('needHelpDesc', context),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: HexColor('#363636'),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          buildIconButton('assets/icons/profileIcons/phone.svg', (){
                            _makePhoneCall('+962117117');
                          }),
                          const SizedBox(width: 10.0),
                          buildIconButton('assets/icons/profileIcons/email.svg', (){
                            _sendEmail('info@ssc.gov.jo');
                          }),
                          const SizedBox(width: 10.0),
                          buildIconButton('assets/icons/profileIcons/whatsapp.svg', (){
                            _openWhatsApp('+962793117117');
                          }),
                        ],
                      ),
                      Divider(
                        thickness: 1,
                        height: 50,
                        color: HexColor('#A6A6A6'),
                      ),
                      Text(
                        translate('officialWorkingDays', context),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: HexColor('#363636'),
                            fontSize: 18
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        translate('officialWorkingDaysDesc', context),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: HexColor('#363636'),
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        height: 50,
                        color: HexColor('#A6A6A6'),
                      ),
                      Text(
                        translate('followUsOnSocialMedia', context),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: HexColor('#363636'),
                            fontSize: 18
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          buildIconButton('assets/icons/profileIcons/facebook.svg', (){
                            _launchInBrowser(Uri(scheme: 'https', path: '//www.facebook.com/JordanSSC'));
                          }),
                          const SizedBox(width: 10.0),
                          buildIconButton('assets/icons/profileIcons/instagram.svg', (){
                            _launchInBrowser(Uri(scheme: 'https', path: '//www.instagram.com/ssc_jordan/'));
                          }),
                          const SizedBox(width: 10.0),
                          buildIconButton('assets/icons/profileIcons/twitter.svg', (){
                            _launchInBrowser(Uri(scheme: 'https', path: '//twitter.com/SSC_Jordan'));
                          }),
                          const SizedBox(width: 10.0),
                          buildIconButton('assets/icons/profileIcons/youtube.svg', (){
                            _launchInBrowser(Uri(scheme: 'https', path: '//www.youtube.com/channel/UCmzVv-X8RmLUYujy9pf1HsA'));
                          }),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildIconButton(icon, void Function() onTap){
    return InkWell(
      onTap: onTap,
      child: SvgPicture.asset(icon),
    );
  }
}
