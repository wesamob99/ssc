// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ssc/src/view/services/shared/servicesListConstants.dart';
import 'package:ssc/src/viewModel/main/mainProvider.dart';
import 'package:ssc/utilities/util.dart';

import '../../../../utilities/hexColor.dart';
import '../../../../utilities/theme/themes.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  List<Service> servicesList = ServicesList.allServices;

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
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: servicesList.length,
            itemBuilder: (context, index){
              return translate(servicesList[index].title, context).contains(mainProvider.searchController.text)
              ? Padding(
                padding: const EdgeInsets.only(bottom: 0.0),
                child: Column(
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => servicesList[index].screen)
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(servicesList[index].icon, width: 30, color: primaryColor,),
                            const SizedBox(width: 10),
                            Text(
                              translate(servicesList[index].title, context) + (servicesList[index].duplicated ? ' ( ${translate(servicesList[index].supTitle, context)} )' : '')
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
      ),
    );
  }

  Widget buildSearchField(ThemeNotifier themeNotifier, MainProvider mainProvider){
    return Container(
      height: height(0.05, context),
      width: width(1, context),
      decoration: BoxDecoration(
          color: Colors.white60,
          borderRadius: BorderRadius.circular(8.0)
      ),
      child: TextFormField(
        controller: mainProvider.searchController,
        style: TextStyle(
            fontSize: isTablet(context) ? 20 : 15,
            color: HexColor('#363636')
        ),
        cursorColor: getPrimaryColor(context, themeNotifier),
        cursorWidth: 1,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.content_paste_search, color: primaryColor,),
            hintText: translate('search', context),
            hintStyle: TextStyle(
              color: getGrey5Color(context).withOpacity(
                themeNotifier.isLight() ? 1 : 0.5,
              ),
              fontSize:  isTablet(context) ? 19 : 14,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: isTablet(context) ? 20 : 0),
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

}
