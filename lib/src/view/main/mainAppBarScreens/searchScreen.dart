// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/infrastructure/userConfig.dart';
import 'package:ssc/src/view/services/shared/servicesListConstants.dart';
import 'package:ssc/src/viewModel/main/mainProvider.dart';
import 'package:ssc/utilities/util.dart';

import '../../../../utilities/hexColor.dart';
import '../../../../utilities/theme/themes.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';
import '../../services/shared/aboutTheServiceScreen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  List<Service> servicesList = ServicesList.allServices;
  List<Service> selectedServices = [];

  @override
  void initState() {
    selectedServices = ServicesList.allServices;
    Provider.of<MainProvider>(context, listen: false).searchController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    MainProvider mainProvider = Provider.of<MainProvider>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height(0.07, context)),
        child: AppBar(
          title: buildSearchField(themeNotifier, mainProvider),
          leading: leadingBackIcon(context),
        )
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: ListView.builder(
                  itemCount: servicesList.length,
                  itemBuilder: (context, index){
                    return (UserConfig.instance.checkLanguage()
                    ? translate(servicesList[index].title, context).toLowerCase().contains(mainProvider.searchController.text.toLowerCase())
                    : translate(servicesList[index].title, context).contains(mainProvider.searchController.text))
                      ? Padding(
                        padding: const EdgeInsets.only(bottom: 0.0),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: (){
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => AboutTheServiceScreen(
                                          serviceScreen: servicesList[index].screen,
                                          serviceTitle: servicesList[index].title,
                                          aboutServiceDescription: servicesList[index].description,
                                          termsOfTheService: const [
                                            'موظفي القطاع الخاص',
                                            'موظف موقوف عن العمل',
                                            'لديك 36 اشتراك او رصيد اكثر من 300 د.ا',
                                            'ان تكون قد استفدت من بدل التعطل ثلاث مرات او اقل خلال فتره الشمول',
                                          ],
                                          stepsOfTheService: const [
                                            'التأكد من المعلومات الشخصية لمقدم الخدمة',
                                            'تعبئة طلب الخدمة',
                                            'تقديم الطلب'
                                          ],
                                          serviceApiCall: servicesList[index].serviceApiCall
                                      )
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(servicesList[index].icon, width: 30, color: primaryColor,),
                                    const SizedBox(width: 10),
                                    SizedBox(
                                      width: width(0.77, context),
                                      child: Text(
                                        translate(servicesList[index].title, context) + (servicesList[index].duplicated ? ' ( ${translate(servicesList[index].supTitle, context)} )' : ''),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if(index != servicesList.length - 1)
                            Divider(
                              color: HexColor('#DEDEDE'),
                              thickness: 0.7,
                            ),
                          ],
                        )
                    ) : const SizedBox.shrink();
                  },
                ),
              ),
              Container(
                alignment: UserConfig.instance.checkLanguage() ? Alignment.topRight : Alignment.topLeft,
                width: width(1, context),
                height: 50,
                child: InkWell(
                    onTap: (){
                      openFilterDialog();
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/filter.png',
                          width: 30,
                          height: 30,
                          color: primaryColor,
                        ),
                        Text(
                          translate('filter', context),
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchField(ThemeNotifier themeNotifier, MainProvider mainProvider){
    return Container(
      height: height(0.05, context),
      width: width(1, context),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8.0)
      ),
      child: TextFormField(
        controller: mainProvider.searchController,
        style: TextStyle(
            fontSize: isTablet(context) ? 20 : 15,
            color: HexColor('#363636')
        ),
        cursorColor: themeNotifier.isLight()
            ? getPrimaryColor(context, themeNotifier)
            : Colors.white,
        cursorWidth: 1,
        decoration: InputDecoration(
          prefixIcon: InkWell(
            onTap: (){
              if(mainProvider.searchController.text.isNotEmpty){
                mainProvider.searchController.text = '';
                mainProvider.notifyMe();
              }
            },
            child: Icon(
              mainProvider.searchController.text.isEmpty
              ? Icons.content_paste_search
              : Icons.cancel_outlined,
              color: primaryColor,
            ),
          ),
          hintText: translate('search', context),
          hintStyle: TextStyle(
            color: getGrey5Color(context).withOpacity(
              themeNotifier.isLight() ? 1 : 0.5,
            ),
            fontSize:  isTablet(context) ? 19 : 14,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: height(0.03, context) / 2),
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
        onChanged: (val){
          mainProvider.notifyMe();
        },
      ),
    );
  }

  Future<void> openFilterDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: Colors.transparent
            )
          ),
          title: Text(
            translate('filter', context),
            style: const TextStyle(
              fontWeight: FontWeight.w500
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: width(1, context),
                height: 35,
                color: primaryColor,
              ),
              const SizedBox(height: 5.0),
              Container(
                width: width(1, context),
                height: 35,
                color: primaryColor.withOpacity(0.6),
              ),
              const SizedBox(height: 5.0),
              Container(
                width: width(1, context),
                height: 35,
                color: primaryColor.withOpacity(0.2),
              )
            ],
          ),
          actions: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: primaryColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        translate('filter', context),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w200
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      child: Text(
                        translate('reset', context),
                        style: TextStyle(
                            color: HexColor('#BC0D0D'),
                            fontWeight: FontWeight.w200
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
