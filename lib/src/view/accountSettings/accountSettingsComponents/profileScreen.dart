// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/src/viewModel/profile/profileProvider.dart';

import '../../../../infrastructure/userSecuredStorage.dart';
import '../../../../models/accountSettings/listOfNationalities.dart';
import '../../../../models/accountSettings/userProfileData.dart';
import '../../../../utilities/hexColor.dart';
import '../../../../utilities/util.dart';
import '../../splash/splashScreen.dart';

class ProfileScreen extends StatefulWidget {
  final List<ListOfNationalities> nationalities;
  const ProfileScreen({Key key, this.nationalities}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Future accountDataFuture;
  ProfileProvider profileProvider;

  @override
  void initState() {
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    accountDataFuture = profileProvider.getAccountData();
    profileProvider.isLoading = false;
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
                      height: height(0.8, context),
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
                                buildDataField('mobileNumber', '${data.mobilenumber}'),
                                buildDataField('email', data.email),
                                buildDataField('countryOfResidence', countryOfResidence.natdesc),
                                buildDataField('homeAddress', 'عمان - دوار الداخليه - خلف مستشفى الأمل'),
                                buildDataField('nationalId', data.userName, withEditIcon: false),
                                buildDataField('DateOfBirth', data.dateofbirth, withEditIcon: false),
                                InkWell(
                                  onTap: () async{
                                    profileProvider.isLoading = true;
                                    profileProvider.notifyMe();
                                    try{
                                      await profileProvider.logout().then((value) {
                                        if(value.toString() == 'true'){
                                          setState(() {
                                            UserSecuredStorage.instance.clearUserData();
                                          });
                                          Navigator.of(context).pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                  builder: (context) => const SplashScreen()
                                              ), (route) => false);
                                        }
                                      });
                                      profileProvider.isLoading = false;
                                      profileProvider.notifyMe();
                                    }catch(e){
                                      profileProvider.isLoading = false;
                                      profileProvider.notifyMe();
                                      if (kDebugMode) {
                                        print(e.toString());
                                      }
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8.0)
                                    ),
                                    width: width(1, context),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset('assets/icons/profileIcons/logout.svg'),
                                        const SizedBox(width: 10.0),
                                        Text(
                                          translate('logout', context),
                                          style: TextStyle(
                                              color: HexColor('#2D452E')
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                        if(Provider.of<ProfileProvider>(context).isLoading)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: width(1, context),
                          height: height(0.8, context),
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

  buildDataField(String title, String data, {bool withEditIcon = true, void Function() onTap}){
    return Container(
      padding: EdgeInsets.all(withEditIcon ? 10.0 : 15.0).copyWith(left: 15, right: 15),
      margin: const EdgeInsets.only(bottom: 15.0),
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
              Text(
                translate(title, context),
                style: TextStyle(
                    color: HexColor('#8B8B8B'),
                    fontSize: 13
                ),
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
