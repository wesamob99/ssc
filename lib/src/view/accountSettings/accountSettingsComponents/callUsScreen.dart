// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../utilities/hexColor.dart';
import '../../../../utilities/util.dart';

class CallUsScreen extends StatelessWidget {
  const CallUsScreen({Key key}) : super(key: key);

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
                          buildIconButton('assets/icons/profileIcons/phone.svg', (){}),
                          const SizedBox(width: 10.0),
                          buildIconButton('assets/icons/profileIcons/email.svg', (){}),
                          const SizedBox(width: 10.0),
                          buildIconButton('assets/icons/profileIcons/whatsapp.svg', (){}),
                        ],
                      ),
                      Divider(
                        thickness: 1,
                        height: 60,
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
                        height: 60,
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
                          buildIconButton('assets/icons/profileIcons/facebook.svg', (){}),
                          const SizedBox(width: 10.0),
                          buildIconButton('assets/icons/profileIcons/instagram.svg', (){}),
                          const SizedBox(width: 10.0),
                          buildIconButton('assets/icons/profileIcons/twitter.svg', (){}),
                          const SizedBox(width: 10.0),
                          buildIconButton('assets/icons/profileIcons/youtube.svg', (){}),
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
