// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/infrastructure/userConfig.dart';
import 'package:ssc/src/view/accountSettings/accountSettingsComponents/updateCountryOfResidence.dart';
import 'package:ssc/src/view/accountSettings/accountSettingsComponents/updateMobileNumberScreen.dart';

import '../../../../infrastructure/userSecuredStorage.dart';
import '../../../../models/accountSettings/listOfNationalities.dart';
import '../../../../models/accountSettings/userProfileData.dart';
import '../../../../utilities/hexColor.dart';
import '../../../../utilities/util.dart';
import '../../../viewModel/accountSettings/accountSettingsProvider.dart';
import '../../splash/splashScreen.dart';

class ProfileScreen extends StatefulWidget {
  final List<ListOfNationalities> nationalities;
  const ProfileScreen({Key key, this.nationalities}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Future accountDataFuture;
  AccountSettingsProvider accountSettingsProvider;

  @override
  void initState() {
    accountSettingsProvider = Provider.of<AccountSettingsProvider>(context, listen: false);
    accountDataFuture = accountSettingsProvider.getAccountData().whenComplete(() {
      accountSettingsProvider.getNationalityData(context);
    });
    accountSettingsProvider.isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(translate('profile', context), style: const TextStyle(fontSize: 14),),
        leading: leadingBackIcon(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
            future: accountDataFuture,
            builder: (context, snapshot){
              switch(snapshot.connectionState){
                case ConnectionState.none:
                  return somethingWrongWidget(context, 'somethingWrongHappened', 'somethingWrongHappenedDesc'); break;
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return Container(
                      height: height(1, context),
                      alignment: Alignment.center,
                      child: animatedLoader(context)
                  ); break;
                case ConnectionState.done:
                  if(snapshot.hasData && !snapshot.hasError){
                    UserProfileData userProfileData = snapshot.data;
                    CurGetdatum data = userProfileData.curGetdata[0][0];
                    ListOfNationalities countryOfResidence = widget.nationalities.where((element) => element.natcode == data.livecontry).first;
                    if (kDebugMode) {
                      print(jsonEncode(data));
                    }
                    return Stack(
                      children: [
                        SingleChildScrollView(
                            child: Column(
                              children: [
                                buildDataField('userName', '${data.firstname ?? ''} ${data.fathername ?? ''} ${data.grandfathername ?? ''} ${data.familyname ?? ''}', withEditIcon: false),
                                buildDataField('mobileNumber', '${data.mobilenumber}', onTap: (){
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => const UpdateMobileNumberScreen())
                                  );
                                }),
                                buildDataField('email', data.email, emailVerified: true),
                                buildDataField('countryOfResidence', UserConfig.instance.checkLanguage() ? countryOfResidence.natdescEn : countryOfResidence.natdesc, onTap: (){
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => UpdateCountryOfResidence(
                                        natCode: countryOfResidence.natcode,
                                      )
                                    )
                                  );
                                }),
                                // buildDataField('homeAddress', 'عمان - دوار الداخليه - خلف مستشفى الأمل'),
                                buildDataField('nationalId', data.userName, withEditIcon: false),
                                buildDataField('securityNumber', data.insuranceno.toString(), withEditIcon: false),
                                buildDataField('DateOfBirth', data.dateofbirth, withEditIcon: false),
                                Container(
                                  padding: const EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.0)
                                  ),
                                  width: width(1, context),
                                  child: InkWell(
                                    onTap: () async{
                                      accountSettingsProvider.isLoading = true;
                                      accountSettingsProvider.notifyMe();
                                      try{
                                        await accountSettingsProvider.logout().then((value) {
                                          // if(value.toString() == 'true'){
                                            setState(() {
                                              UserSecuredStorage.instance.clearUserData();
                                            });
                                            Navigator.of(context).pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) => const SplashScreen()
                                                ), (route) => false);
                                          // }
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
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset('assets/icons/profileIcons/logout.svg', color: HexColor('#BC0D0D')),
                                        const SizedBox(width: 10.0),
                                        Text(
                                          translate('logout', context),
                                          style: TextStyle(
                                              color: HexColor('#BC0D0D')
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                        if(Provider.of<AccountSettingsProvider>(context).isLoading)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: width(1, context),
                          height: height(1, context),
                          color: Colors.white70,
                          child: Center(
                            child: animatedLoader(context),
                          ),
                        )
                      ],
                    );
                  }
                  break;
              }
              return somethingWrongWidget(context, 'somethingWrongHappened', 'somethingWrongHappenedDesc');
            }
        ),
      ),
    );
  }

  buildDataField(String title, String data, {bool withEditIcon = true, void Function() onTap, bool emailVerified = false}){
    return Container(
      padding: EdgeInsets.all(withEditIcon ? emailVerified ? 5.0 : 10.0 : 15.0).copyWith(left: 15, right: 15),
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0)
      ),
      width: width(1, context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    translate(title, context),
                    style: TextStyle(
                        color: HexColor('#8B8B8B'),
                        fontSize: 13
                    ),
                  ),
                  const SizedBox(width: 10.0,),
                  if(emailVerified)
                  SvgPicture.asset('assets/icons/profileIcons/verified.svg'),
                ],
              ),
              if(withEditIcon)
              InkWell(
                onTap: onTap,
                child: SvgPicture.asset('assets/icons/profileIcons/edit.svg'),
              )
            ],
          ),
          SizedBox(height: withEditIcon ? 5.0 : 10.0),
          Text(
            data,
            style: TextStyle(
                color: HexColor('#51504E'),
                fontWeight: FontWeight.w600
            ),
          ),
        ],
      ),
    );
  }
}
