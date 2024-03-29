// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssc/source/viewModel/accountSettings/accountSettingsProvider.dart';
import '../../../../infrastructure/userConfig.dart';
import '../../../../utilities/hexColor.dart';
import '../../../../utilities/theme/themes.dart';
import '../../../../utilities/util.dart';
import '../../../viewModel/utilities/theme/themeProvider.dart';

class FrequentlyAskedQuestionsScreen extends StatefulWidget {
  const FrequentlyAskedQuestionsScreen({Key key}) : super(key: key);

  @override
  State<FrequentlyAskedQuestionsScreen> createState() => _FrequentlyAskedQuestionsScreenState();
}

class _FrequentlyAskedQuestionsScreenState extends State<FrequentlyAskedQuestionsScreen> {

  AccountSettingsProvider accountSettingsProvider;
  ThemeNotifier themeNotifier;
  List<String> filterList = ['generalQuestions', 'accountAndRegistration', 'payingOff', 'bottomServices'];
  List frequentlyAskedQuestionsList = [
    {'question': 'whatIsSocialSecurity', 'answer': 'loremIpsum'},
    {'question': 'howCanIBenefitFromSocialSecurityServices', 'answer': 'loremIpsum'},
    {'question': 'howDoIApplyToWorkOnSocialSecurity', 'answer': 'loremIpsum'}
  ];
  int indexSelected = 0;
  bool showSearchBar = false;

  @override
  void initState() {
    accountSettingsProvider = Provider.of<AccountSettingsProvider>(context, listen: false);
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    accountSettingsProvider.searchController.text = "";
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(getTranslated('frequentlyAskedQuestions', context), style: const TextStyle(fontSize: 14),),
        leading: leadingBackIcon(context),
        actions: [
          IconButton(
            onPressed: (){
              setState(() {
                showSearchBar = !showSearchBar;
              });
            },
            icon: Icon(
              showSearchBar ? Icons.filter_list: Icons.search,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(showSearchBar)
                      SizedBox(
                        width: width(1, context),
                        child: buildSearchField(themeNotifier, accountSettingsProvider),
                      ),
                    if(!showSearchBar)
                      SizedBox(
                        width: width(1, context),
                        height: 60,
                        child: ListView.builder(
                            itemCount: filterList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index){
                              return Row(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      setState(() {
                                        indexSelected = index;
                                      });
                                    },
                                    highlightColor: HexColor('#2D452E').withOpacity(0.2),
                                    splashColor: Colors.transparent,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                      decoration: BoxDecoration(
                                          color: indexSelected == index ? HexColor('#F0F2F0') : Colors.transparent,
                                          borderRadius: BorderRadius.circular(50.0),
                                          border: Border.all(
                                              color: indexSelected == index ? Colors.transparent : const Color.fromRGBO(81, 80, 78, 0.13),
                                              width: 1
                                          )
                                      ),
                                      child: Text(
                                        getTranslated(filterList[index], context),
                                        style: TextStyle(
                                          color: indexSelected == index ? HexColor('#2D452E') : HexColor('#51504E'),
                                          fontSize: 13
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0,)
                                ],
                              );
                            }
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                flex: 8,
                child: ListView.builder(
                    itemCount: frequentlyAskedQuestionsList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index){
                      return (UserConfig.instance.isLanguageEnglish()
                      ? getTranslated(frequentlyAskedQuestionsList[index]['question'], context).toLowerCase().contains(accountSettingsProvider.searchController.text.toLowerCase())
                      : getTranslated(frequentlyAskedQuestionsList[index]['question'], context).contains(accountSettingsProvider.searchController.text))
                      ? Column(
                        children: [
                          buildExpandableWidget(
                            context,
                            frequentlyAskedQuestionsList[index]['question'],
                            frequentlyAskedQuestionsList[index]['answer'],
                          ),
                          const SizedBox(height: 15.0,)
                        ],
                      ) : const SizedBox.shrink();
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchField(ThemeNotifier themeNotifier, AccountSettingsProvider accountSettingsProvider){
    return Container(
      height: height(0.05, context),
      width: width(1, context),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8.0)
      ),
      child: TextFormField(
        controller: accountSettingsProvider.searchController,
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
                if(accountSettingsProvider.searchController.text.isNotEmpty){
                  accountSettingsProvider.searchController.text = '';
                  accountSettingsProvider.notifyMe();
                }
              },
              child: Icon(
                Provider.of<AccountSettingsProvider>(context).searchController.text.isEmpty
                    ? Icons.content_paste_search
                    : Icons.cancel_outlined,
                color: primaryColor,
              ),
            ),
            hintText: getTranslated('search', context),
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
          accountSettingsProvider.notifyMe();
        },
      ),
    );
  }

}


